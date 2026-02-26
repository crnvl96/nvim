Config.now(function()
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = Config.gr,
    callback = function() vim.highlight.on_yank() end,
  })

  vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = Config.gr,
    pattern = '[^l]*',
    command = 'cwindow',
  })

  vim.api.nvim_create_autocmd('VimResized', {
    group = Config.gr,
    callback = function()
      local current_tab = vim.api.nvim_get_current_tabpage()
      vim.cmd('tabdo wincmd =')
      vim.api.nvim_set_current_tabpage(current_tab)
    end,
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    callback = function(e)
      local bufnr = e.buf
      local filetype = vim.bo[bufnr].ft
      local types = { 'help', 'checkhealth', 'vim', '' }
      for _, b in ipairs(types) do
        if filetype == b then
          vim.keymap.set('n', 'q', function() vim.api.nvim_command('close') end, { buffer = true })
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdlineEnter' }, {
    group = Config.gr,
    callback = vim.schedule_wrap(function() vim.cmd.nohlsearch() end),
  })

  vim.api.nvim_create_autocmd('TermEnter', {
    group = Config.gr,
    callback = function()
      local code_term_esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)
      for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
        vim.keymap.set('t', '<C-' .. key .. '>', function()
          local code_dir = vim.api.nvim_replace_termcodes('<C-' .. key .. '>', true, true, true)
          vim.api.nvim_feedkeys(code_term_esc .. code_dir, 't', true)
        end, { noremap = true })
      end
    end,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = Config.gr,
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end
      if client.name == 'gopls' then
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        if not client.server_capabilities.semanticTokensProvider then
          local semantic = client.config.capabilities.textDocument.semanticTokens
          if not semantic then return end
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = { tokenTypes = semantic.tokenTypes, tokenModifiers = semantic.tokenModifiers },
            range = true,
          }
        end
      end
    end,
  })
end)
