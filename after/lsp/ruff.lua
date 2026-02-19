---@type vim.lsp.Config
return {
  settings = {},
  init_options = {
    settings = {
      logLevel = 'debug',
      fixAll = true,
      organizeImports = true,
      lint = { enable = true },
      format = { backend = 'uv' },
    },
  },
  capabilities = {
    general = { positionEncodings = { 'utf-16' } },
  },
  ---@diagnostic disable-next-line: unused-local
  on_attach = function(client, bufnr) client.server_capabilities.hoverProvider = false end,
}
