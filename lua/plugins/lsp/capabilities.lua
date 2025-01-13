local register_capability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then return end
  require('plugins.lsp.on_attach')(client, vim.api.nvim_get_current_buf())
  return register_capability(err, res, ctx)
end

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
