vim.opt.completeopt:append('fuzzy')
vim.opt.wildoptions:append('fuzzy')

vim.g.mkdp_filetypes = { 'markdown', 'md' }

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local register_capability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then return end
  Config.on_attach(client, vim.api.nvim_get_current_buf())
  return register_capability(err, res, ctx)
end

vim.diagnostic.config({
  float = { border = 'single' },
  signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
  virtual_text = { severity = { min = 'ERROR', max = 'ERROR' } },
  update_in_insert = false,
})
