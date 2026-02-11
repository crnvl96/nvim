MiniDeps.now(function()
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('crnvl96-highlight-on-yank', { clear = true }),
    callback = function() vim.highlight.on_yank() end,
  })

  vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = vim.api.nvim_create_augroup('crnvl96-auto-open-qf', { clear = true }),
    pattern = { '[^l]*' },
    command = 'cwindow',
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lspattach-maps', { clear = true }),
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)

      if not client then return end

      vim.lsp.document_color.enable(true, e.buf)
      vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })

      local under_cursor_highlights_group = vim.api.nvim_create_augroup('crnvl96-cursor-highlight', { clear = false })

      vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
        group = under_cursor_highlights_group,
        buffer = e.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
        group = under_cursor_highlights_group,
        buffer = e.buf,
        callback = vim.lsp.buf.clear_references,
      })

      vim.keymap.set(
        'n',
        ']e',
        function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end,
        { buffer = e.buf }
      )
      vim.keymap.set(
        'n',
        '[e',
        function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end,
        { buffer = e.buf }
      )
      vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, { buffer = e.buf })
      vim.keymap.set('n', 'E', function() vim.diagnostic.open_float() end, { buffer = e.buf })
      vim.keymap.set('i', '<C-k>', function() vim.lsp.buf.signature_help() end, { buffer = e.buf })
      vim.keymap.set('i', '<CR>', function()
        local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end
        return pumvisible() and '<C-y>' or '<CR>'
      end, { expr = true, buffer = e.buf })

      for _, k in ipairs({ '<C-n>', '<Tab>' }) do
        vim.keymap.set('i', k, function()
          local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end
          local function feed(key)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', true)
          end

          if pumvisible() then
            feed('<C-n>')
          else
            if next(vim.lsp.get_clients({ bufnr = 0 })) then
              vim.lsp.completion.get()
            else
              if vim.bo.omnifunc == '' then
                feed('<C-x><C-n>')
              else
                feed('<C-x><C-o>')
              end
            end
          end
        end, { buffer = e.buf })
      end

      for _, k in ipairs({ '<C-p>', '<S-Tab>' }) do
        vim.keymap.set('i', k, function()
          local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end
          local function feed(key)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', true)
          end

          if pumvisible() then
            feed('<C-p>')
          else
            if next(vim.lsp.get_clients({ bufnr = 0 })) then
              vim.lsp.completion.get()
            else
              if vim.bo.omnifunc == '' then
                feed('<C-x><C-p>')
              else
                feed('<C-x><C-o>')
              end
            end
          end
        end, { buffer = e.buf })
      end
    end,
  })
end)
