---@type vim.lsp.Config
return {
  ---@diagnostic disable-next-line: unused-local
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
