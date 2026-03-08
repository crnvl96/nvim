vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

vim.lsp.enable(Config.servers)

vim.api.nvim_create_autocmd('LspAttach', {
  group = Config.gr,
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    --
    -- Gopls extra config
    --
    if client.name == 'gopls' then
      -- workaround for gopls not supporting semanticTokensProvider
      -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
      if not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        if not semantic then return end
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = semantic.tokenTypes,
            tokenModifiers = semantic.tokenModifiers,
          },
          range = true,
        }
      end
    end
  end,
})

vim.keymap.set('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Open Current Diagnostic' })
vim.keymap.set('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { desc = 'Inspect Current Symbol' })
vim.keymap.set('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = 'Show Signature Help' })
vim.keymap.set('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'LSP Code actions' })
vim.keymap.set('n', '<Leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'LSP Rename' })
