local methods = vim.lsp.protocol.Methods

local diagnostic_icons = {
  ERROR = 'E',
  WARN = 'W',
  HINT = 'H',
  INFO = 'I',
}

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    spacing = 2,
    format = function(diagnostic)
      local special_sources = {
        ['Lua Diagnostics.'] = 'lua',
        ['Lua Syntax Check.'] = 'lua',
      }

      local message = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]

      if diagnostic.source then
        message = string.format(
          '%s %s',
          message,
          special_sources[diagnostic.source] or diagnostic.source
        )
      end

      if diagnostic.code then
        message = string.format('%s[%s]', message, diagnostic.code)
      end

      return message .. ' '
    end,
  },
  float = {
    source = 'if_many',
    prefix = function(diag)
      local level = vim.diagnostic.severity[diag.severity]
      local prefix = string.format(' %s ', diagnostic_icons[level])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
  },
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

  if client:supports_method(methods.textDocument_formatting) then
    client.server_capabilities.documentFormattingProvider = true
  end

  if client:supports_method(methods.textDocument_documentColor) then
    local enable = true
    vim.lsp.document_color.enable(enable, bufnr)
  end

  if client:supports_method(methods.textDocument_foldingRange) then
    vim.wo[vim.api.nvim_get_current_win()][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  else
    vim.wo[vim.api.nvim_get_current_win()][0].foldexpr =
      'v:lua.vim.treesitter.foldexpr()'
  end
end

local signature = vim.lsp.protocol.Methods.client_registerCapability
local register_capability = vim.lsp.handlers[signature]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(
  err,
  res,
  ctx
)
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
