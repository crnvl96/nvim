---@type vim.lsp.Config
return {
  settings = {
    yaml = {
      schemastore = { enable = false, url = '' },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
}
