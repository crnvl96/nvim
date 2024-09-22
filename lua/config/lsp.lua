local methods = vim.lsp.protocol.Methods

-- stylua: ignore
local function on_attach(client, bufnr)
  local function set_method(method, lhs, rhs, desc, mode)
    if client.supports_method(method) then vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr }) end
  end

  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  set_method(methods.textDocument_definition, 'grd', function() require('fzf-lua').lsp_definitions() end, 'LSP Definitions')
  set_method(methods.textDocument_references, 'grr', function() require('fzf-lua').lsp_references() end, 'LSP References')
  set_method(methods.textDocument_implementation, 'gri', function() require('fzf-lua').lsp_implementations() end, 'LSP Impls')
  set_method(methods.textDocument_typeDefinition, 'gry', function() require('fzf-lua').lsp_typedefs() end, 'LSP Typedefs')
  set_method(methods.textDocument_codeAction, 'gra', function() require('fzf-lua').lsp_code_actions() end, 'LSP Code actions')
  set_method(methods.textDocument_documentSymbol, 'grs', function() require('fzf-lua').lsp_document_symbols() end, 'LSP Document symbols')
  set_method(methods.workspace_symbol, 'grS', function() require('fzf-lua').lsp_workspace_symbols() end, 'LSP Workspace symbols')
  set_method(methods.textDocument_diagnostic, 'grx', function() require('fzf-lua').lsp_document_diagnostics() end, 'LSP Document diagnostics')
  set_method(methods.workspace_diagnostic, 'grX', function() require('fzf-lua').lsp_workspace_diagnostics() end, 'LSP Workspace diagnostics')
  set_method(methods.textDocument_rename, 'grn', function() vim.lsp.buf.rename() end, 'Rename symbol')
  set_method(methods.textDocument_signatureHelp, '<C-k>', function() vim.lsp.buf.signature_help() end, 'Signature help', 'i')
  set_method(methods.textDocument_inlayHint, '<Leader>ci', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr }) end, 'Toggle inlay hints')
end

local diagnostic_icons = {
  ERROR = ' ',
  WARN = ' ',
  HINT = ' ',
  INFO = ' ',
}

vim.diagnostic.config({
  virtual_text = {
    prefix = '',
    spacing = 2,
    format = function(diagnostic)
      local special_sources = {
        ['Lua Diagnostics.'] = 'lua',
        ['Lua Syntax Check.'] = 'lua',
      }

      local source = special_sources[diagnostic.source] or diagnostic.source
      local icon = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
      return string.format('%s %s[%s] ', icon, source, diagnostic.code)
    end,
  },
  float = {
    border = 'rounded',
    source = 'if_many',
    prefix = function(diag)
      local level = vim.diagnostic.severity[diag.severity]
      local prefix = string.format(' %s ', diagnostic_icons[level])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
  },
  signs = false,
})

local register_capability = vim.lsp.handlers[methods.client_registerCapability]

vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then return end

  on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    on_attach(client, e.buf)
  end,
})
