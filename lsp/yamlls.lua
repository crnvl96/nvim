return {
  on_init = function(client) client.server_capabilities.documentFormattingProvider = true end,
  settings = {
    yaml = {
      format = { enable = true },
      schemastore = { enable = false, url = '' },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
}
