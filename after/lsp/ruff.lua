---@type vim.lsp.Config
return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
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
    general = {
      positionEncodings = { 'utf-16' },
    },
  },
  ---@diagnostic disable-next-line: unused-local
  on_attach = function(client, bufnr) client.server_capabilities.hoverProvider = false end,
}
