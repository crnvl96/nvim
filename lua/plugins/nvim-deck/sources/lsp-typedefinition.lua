return function()
  local bufnr = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_position_params(0, vim.lsp.util._get_offset_encoding(bufnr))

  require('deck').start({
    name = 'LSP type definition',
    execute = function(ctx)
      vim.lsp.buf_request_all(0, 'textDocument/typeDefinition', params, function(results)
        if not results or vim.tbl_isempty(results) then return ctx.done() end

        for _, result in pairs(results) do
          if result.result then
            local locations = vim.tbl_islist(result.result) and result.result or { result.result }

            for _, location in ipairs(locations) do
              local uri = location.uri or location.targetUri
              local range = location.range or location.targetRange
              local filename = vim.uri_to_fname(uri)

              local line_text = ''
              local lines = vim.fn.readfile(filename)
              if lines and #lines >= (range.start.line + 1) then
                line_text = ' ' .. vim.trim(lines[range.start.line + 1])
              end

              ctx.item({
                display_text = string.format('%s:%d', vim.fn.fnamemodify(filename, ':~:.'), range.start.line + 1),
                data = {
                  filename = filename,
                  lnum = range.start.line + 1,
                  col = range.start.character + 1,
                  text = line_text,
                },
              })
            end
          end
        end

        ctx.done()
      end)
    end,
    actions = {
      require('deck').alias_action('default', 'open'),
    },
    decorators = {
      {
        name = 'LSP type definition',
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
