return vim.lsp.config('bacon_ls', {
  init_options = {
    updateOnSave = true,
    updateOnSaveWaitMillis = 1000,
  },
})
