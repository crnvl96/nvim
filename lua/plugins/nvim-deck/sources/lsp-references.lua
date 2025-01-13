return function()
  local bufnr = vim.api.nvim_get_current_buf()

  local params = vim.tbl_deep_extend(
    'force',
    vim.lsp.util.make_position_params(0, vim.lsp.util._get_offset_encoding(bufnr)) or {},
    { context = { includeDeclaration = true } }
  )

  local clients = vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/references' })

  require('deck').start({
    name = 'LSP references',
    execute = function(ctx)
      if #clients == 0 then
        vim.notify('No LSP clients support textDocument/references')
        ctx.done()
        return
      end

      clients[1].request('textDocument/references', params, function(_, results)
        if not results then
          ctx.done()
          return
        end

        for _, location in ipairs(results) do
          local filename = vim.uri_to_fname(location.uri)
          local range = location.range

          local line_text = ''
          local lines = vim.fn.readfile(filename)
          if lines and #lines >= (range.start.line + 1) then
            line_text = ' ' .. vim.trim(lines[range.start.line + 1])
          end

          ctx.item({
            display_text = string.format(
              '%s:%d:%d',
              vim.fn.fnamemodify(filename, ':~:.'),
              range.start.line + 1,
              range.start.character + 1
            ),
            data = {
              filename = filename,
              lnum = range.start.line + 1,
              col = range.start.character + 1,
              text = line_text,
            },
          })
        end
        ctx.done()
      end, bufnr)
    end,
    actions = { require('deck').alias_action('default', 'open') },
    decorators = {
      {
        name = 'LSP References',
        resolve = function(_, item) return item.data.filename end,
        decorate = function(_, item, row)
          local relfilename = vim.fn.fnamemodify(item.data.filename, ':~:.')
          local filename = vim.fn.fnamemodify(item.data.filename, ':t')
          local dirname = vim.fn.fnamemodify(relfilename, ':r')
          return {
            {
              row = row,
              virt_text = {
                { dirname .. '/', 'Comment' },
                { filename, 'Special' },
                { ':' .. item.data.lnum .. ':' .. item.data.col, 'Number' },
                { item.data.text, 'Normal' },
              },
              virt_text_pos = 'overlay',
            },
          }
        end,
      },
    },
  })
end
