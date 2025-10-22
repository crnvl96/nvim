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
  on_attach = function(client, _bufnr) client.server_capabilities.hoverProvider = false end,
}
