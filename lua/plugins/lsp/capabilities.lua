local ok = pcall(require, 'blink.cmp')
if not ok then vim.notify('blink.cmp must be installed to have access to full capabilities.', vim.log.levels.ERROR) end

return require('blink.cmp').get_lsp_capabilities(
  vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
      },
    },
  })
)
