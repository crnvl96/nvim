return vim.lsp.config('jsonls', {
  settings = {
    json = {
      validate = { enable = true },
      schemas = require('schemastore').json.schemas(),
    },
  },
})
