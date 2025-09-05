return vim.lsp.config('ruff', {
  init_options = {
    settings = { logLevel = 'debug' },
  },
})
