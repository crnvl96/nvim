Config.now(function()
  vim.api.nvim_create_autocmd('TextYankPost', { group = Config.gr, command = 'lua vim.highlight.on_yank()' })

  vim.api.nvim_create_autocmd('QuickFixCmdPost', { group = Config.gr, pattern = '[^l]*', command = 'cwindow' })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = Config.gr,
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end
      local methods = vim.lsp.protocol.Methods

      local sup = function(method) return client:supports_method(method, e.buf) end
      local pumvisible = function() return tonumber(vim.fn.pumvisible()) ~= 0 end
      local feed = function(key)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', true)
      end

      local set = function(mode, lhs, rhs, opts)
        opts = opts or {}
        local ext_opts = vim.tbl_extend('error', { buffer = e.buf }, opts)
        vim.keymap.set(mode, lhs, rhs, ext_opts)
      end

      local complete = function(map)
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

      if sup(methods.textDocument_documentColor) then vim.lsp.document_color.enable(true, e.buf) end

      if sup(methods.textDocument_completion) then
        vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })

        local f_confirm = function() return pumvisible() and '<C-y>' or '<CR>' end
        set('i', '<CR>', f_confirm, { expr = true })

        for _, k in ipairs({ '<C-n>', '<Tab>' }) do
          local f_next = function() complete('<C-n>') end
          set('i', k, f_next)
        end

        for _, k in ipairs({ '<C-p>', '<S-Tab>' }) do
          local f_prev = function() complete('<C-p>') end
          set('i', k, f_prev)
        end
      end

      if sup(methods.textDocument_documentHighlight) then
        local hl = vim.api.nvim_create_augroup('crnvl96-cursor-highlight', { clear = false })

        vim.api.nvim_create_autocmd(
          { 'CursorHold', 'InsertLeave' },
          { group = hl, buffer = e.buf, command = 'lua vim.lsp.buf.document_highlight()' }
        )
        vim.api.nvim_create_autocmd(
          { 'CursorMoved', 'InsertEnter', 'BufLeave' },
          { group = hl, buffer = e.buf, command = 'lua vim.lsp.buf.clear_references()' }
        )
      end

      if sup(methods.textDocument_publishDiagnostics) then
        local nxt = '<Cmd>lua vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })<CR>'
        set('n', ']e', nxt, { desc = 'Next err' })

        local prev = '<Cmd>lua vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })<CR>'
        set('n', '[e', prev, { desc = 'Prev err' })

        local open = '<Cmd>lua vim.diagnostic.open_float()<CR>'
        set('n', 'E', open)
      end

      if sup(methods.textDocument_hover) then
        local hv = '<Cmd>lua vim.lsp.buf.hover()<CR>'
        set('n', 'K', hv)
      end

      if sup(methods.textDocument_signatureHelp) then
        local sh = '<Cmd>lua vim.lsp.buf.signature_help()<CR>'
        set('i', '<C-k>', sh)
      end

      if sup(methods.textDocument_declaration) then
        local decl = "<Cmd>lua MiniExtra.pickers.lsp({scope ='declaration'})<CR>"
        set('n', '<Leader>lD', decl, { desc = 'Declarations' })
      end

      if sup(methods.textDocument_definition) then
        local def = "<Cmd>lua MiniExtra.pickers.lsp({scope='definition'})<CR>"
        set('n', '<Leader>ld', def, { desc = 'Definitions' })
      end

      if sup(methods.textDocument_documentSymbol) then
        local ds = "<Cmd>lua MiniExtra.pickers.lsp({scope='document_symbol'})<CR>"
        set('n', '<Leader>ls', ds, { desc = 'Symbols' })

        local ws = "<Cmd>lua MiniExtra.pickers.lsp({scope='workspace_symbol_live'})<CR>"
        set('n', '<Leader>lS', ws, { desc = 'Workspace symbols' })
      end

      if sup(methods.textDocument_implementation) then
        local impl = "<Cmd>lua MiniExtra.pickers.lsp({scope='implementation'})<CR>"
        set('n', '<Leader>li', impl, { desc = 'Implementations' })
      end

      if sup(methods.textDocument_references) then
        local ref = "<Cmd>lua MiniExtra.pickers.lsp({scope='references'})<CR>"
        set('n', '<Leader>lr', ref, { desc = 'References' })
      end

      if sup(methods.textDocument_typeDefinition) then
        local typedef = "<Cmd>lua MiniExtra.pickers.lsp({scope='type_definition'})<CR>"
        set('n', '<Leader>lt', typedef, { desc = 'Typedefs' })
      end

      if sup(methods.textDocument_codeAction) then
        local ca = '<Cmd>lua vim.lsp.buf.code_action()<CR>'
        set('n', '<Leader>la', ca, { desc = 'Code actions' })
      end

      if sup(methods.textDocument_rename) then
        local ren = '<Cmd>lua vim.lsp.buf.rename()<CR>'
        set('n', '<Leader>ln', ren, { desc = 'Rename' })
      end
    end,
  })
end)
