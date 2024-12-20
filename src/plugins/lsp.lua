Add('neovim/nvim-lspconfig')

local capabilities = require('blink.cmp').get_lsp_capabilities()

local function root_dir(buffer, list)
  if not buffer then return nil end
  return vim.fs.root(buffer, list)
end

-- Enhance LSP client registration by automatically calling on_attach
-- when a language server registers its capabilities, ensuring custom
-- setup is applied to newly connected LSP clients
local register_capability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then return end
  Config.on_attach(client, vim.api.nvim_get_current_buf())
  return register_capability(err, res, ctx)
end

require('lspconfig').vtsls.setup({
  capabilities = capabilities,
  root_dir = function(_, buffer) return root_dir(buffer, { 'package.json' }) end,
  single_file_support = false, -- avoid setting up vtsls on deno projects
})

require('lspconfig').denols.setup({
  capabilities = capabilities,
  root_dir = function(_, buffer) return root_dir(buffer, { 'deno.json', 'deno.jsonc' }) end,
})

require('lspconfig').basedpyright.setup({
  capabilities = capabilities,
  settings = {
    basedpyright = {
      typeCheckingMode = 'basic', -- Options: "off", "basic", "strict"
    },
  },
})

require('lspconfig').lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      codeLens = { enable = true },
      doc = { privateName = { '^_' } },
    },
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', { clear = true }),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    Config.on_attach(client)
  end,
})
