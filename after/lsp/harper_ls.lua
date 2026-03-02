---@type vim.lsp.Config
return {
  settings = {
    ['harper-ls'] = {
      linters = {
        SentenceCapitalization = false,
        SpellCheck = false,
      },
    },
  },
}
