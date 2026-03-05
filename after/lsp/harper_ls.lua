---@type vim.lsp.Config
return {
  settings = {
    ['harper-ls'] = {
      linters = {
        SentenceCapitalization = true,
        SpellCheck = true,
      },
    },
  },
}
