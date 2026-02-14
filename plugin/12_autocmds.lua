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

      local m = vim.lsp.protocol.Methods
      local function sup(method) return client:supports_method(method, e.buf) end

      if sup(m.textDocument_documentColor) then vim.lsp.document_color.enable(true, e.buf) end

      if sup(m.textDocument_completion) then
        vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })

        vim.keymap.set('i', '<CR>', function()
          local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end
          return pumvisible() and '<C-y>' or '<CR>'
        end, { expr = true, buffer = e.buf })

        local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end
        local function feed(key)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', true)
        end

        local function trigger_completion_algorithm(map)
          if pumvisible() then
            feed(map)
          else
            if next(vim.lsp.get_clients({ bufnr = 0 })) then
              vim.lsp.completion.get()
            else
              if vim.bo.omnifunc == '' then
                feed('<C-x>' .. map)
              else
                feed('<C-x><C-o>')
              end
            end
          end
        end

        for _, k in ipairs({ '<C-n>', '<Tab>' }) do
          vim.keymap.set('i', k, function() trigger_completion_algorithm('<C-n>') end, { buffer = e.buf })
        end

        for _, k in ipairs({ '<C-p>', '<S-Tab>' }) do
          vim.keymap.set('i', k, function() trigger_completion_algorithm('<C-p>') end, { buffer = e.buf })
        end
      end

      if sup(m.textDocument_documentHighlight) then
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
      end

      if sup(m.textDocument_publishDiagnostics) then
        vim.keymap.set(
          'n',
          ']e',
          function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end,
          { buffer = e.buf, desc = 'Goto next error' }
        )
        vim.keymap.set(
          'n',
          '[e',
          function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end,
          { buffer = e.buf, desc = 'Goto previous error' }
        )
        vim.keymap.set('n', 'E', function() vim.diagnostic.open_float() end, { buffer = e.buf })
      end

      if sup(m.textDocument_hover) then
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, { buffer = e.buf })
      end

      if sup(m.textDocument_signatureHelp) then
        vim.keymap.set('i', '<C-k>', function() vim.lsp.buf.signature_help() end, { buffer = e.buf })
      end
    end,
  })
end)
