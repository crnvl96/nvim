local methods = vim.lsp.protocol.Methods

vim.diagnostic.config {
  virtual_text = true,
  virtual_lines = false,
  float = true,
  signs = false,
}

local function on_attach(client, bufnr)
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  local set = function(lhs, rhs, opts, mode)
    opts = vim.tbl_extend('error', opts or {}, { buffer = bufnr })
    mode = mode or 'n'
    return vim.keymap.set(mode, lhs, rhs, opts)
  end

  set('E', vim.diagnostic.open_float)
  set('K', vim.lsp.buf.hover)
  set('ga', vim.lsp.buf.code_action)
  set('gn', vim.lsp.buf.rename)
  set('gd', vim.lsp.buf.definition)
  set('gD', vim.lsp.buf.declaration)
  set('gr', vim.lsp.buf.references, { nowait = true })
  set('gi', vim.lsp.buf.implementation)
  set('gy', vim.lsp.buf.type_definition)
  set('ge', vim.diagnostic.setqflist)
  set('gs', vim.lsp.buf.document_symbol)
  set('gS', vim.lsp.buf.workspace_symbol)
  set('<C-k>', vim.lsp.buf.signature_help, {}, 'i')

  if client:supports_method(methods.textDocument_inlayHint) then
    local toggle = function()
      local enabled = vim.lsp.inlay_hint.is_enabled()
      vim.lsp.inlay_hint.enable(not enabled)
      vim.notify(
        enabled and 'Enabled' or 'Disabled' .. ' inlay hints.',
        vim.log.levels.INFO
      )
    end

    set('g=', toggle)
  end

  if client:supports_method(methods.textDocument_formatting) then
    client.server_capabilities.documentFormattingProvider = true
  end

  if client:supports_method(methods.textDocument_documentColor) then
    vim.lsp.document_color.enable(true, bufnr)
  end

  local win = vim.api.nvim_get_current_win()

  if client:supports_method(methods.textDocument_foldingRange) then
    vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  else
    vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end
end

local signature = vim.lsp.protocol.Methods.client_registerCapability
local register_capability = vim.lsp.handlers[signature]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then return end
  on_attach(client, vim.api.nvim_get_current_buf())
  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    on_attach(client, args.buf)
  end,
})
