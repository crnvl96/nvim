return function()
  local severity = { 'ERROR', 'WARN', 'HINT', 'INFO' }

  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)

  local diags = vim.diagnostic.get(bufnr, severity)
  table.sort(diags, function(a, b) return a.severity < b.severity end)

  if not diags or #diags == 0 then
    vim.print('No diagnostics for this buffer.')
    return
  end

  require('deck').start({
    name = 'Buffer diagnostics',
    execute = function(ctx)
      for _, diag in ipairs(diags) do
        ctx.item({
          data = {
            filename = filename,
            bufname = vim.fn.fnamemodify(filename, ':t'),
            bufnr = diag.bufnr,
            lnum = diag.lnum + 1,
            col = diag.col,
            diagnostics = diag,
          },
          display_text = {
            { ('(%s:%s): %s'):format(diag.lnum + 1, diag.col + 1, diag.message) },
          },
        })
      end
      ctx.done()
    end,
    actions = { require('deck').alias_action('default', 'open') },
    decorators = {
      {
        name = 'Buffer diagnostics',
        resolve = function(_, item) return item.data.diagnostics end,
        decorate = function(_, item, row)
          local icons = {
            [vim.diagnostic.severity.ERROR] = 'E',
            [vim.diagnostic.severity.WARN] = 'W',
            [vim.diagnostic.severity.HINT] = 'H',
            [vim.diagnostic.severity.INFO] = 'I',
          }

          local hls = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
          }

          local bufname = item.data.bufname
          local icon = icons[item.data.diagnostics.severity]
          local hl = hls[item.data.diagnostics.severity]

          return {
            {
              row = row,
              col = 0,
              virt_text = { { '  ' .. icon .. '  ', hl } },
              virt_text_pos = 'inline',
            },
            {
              row = row,
              col = 0,
              virt_text = { { bufname, 'Comment' } },
              virt_text_pos = 'right_align',
            },
          }
        end,
      },
    },
  })
end
