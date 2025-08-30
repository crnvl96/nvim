vim.lsp.config('*', {
  capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    general = {
      positionEncodings = {
        'utf-16',
      },
    },
  }),
})

local servers = {
  all = vim.fn.glob(os.getenv('HOME') .. '/.config/nvim/lsp/*.lua', true, true),
  allowed = {},
  prohibited = { 'rust_analyzer' },
}

for _, file in ipairs(servers.all) do
  local server_name = vim.fn.fnamemodify(file, ':t:r')
  local is_server_allowed = not vim.tbl_contains(servers.prohibited, server_name)
  if is_server_allowed then
    table.insert(servers.allowed, server_name)
    local content = assert(loadfile(file))
    vim.lsp.config(server_name, content())
  end
end

vim.lsp.enable(servers.allowed)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', { clear = true }),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    local set = function(lhs, rhs, desc, mode)
      return vim.keymap.set(mode or 'n', lhs, rhs, { buffer = e.buf, desc = desc, nowait = true })
    end
    set('E', vim.diagnostic.open_float, 'Show Error')
    set('K', vim.lsp.buf.hover, 'Hover')
    set('ga', vim.lsp.buf.code_action, 'Code Actions')
    set('gn', vim.lsp.buf.rename, 'Rename Symbol')
    set('gd', vim.lsp.buf.definition, 'Goto Definition')
    set('gD', vim.lsp.buf.declaration, 'Goto Declaration')
    set('gr', vim.lsp.buf.references, 'Goto References')
    set('gi', vim.lsp.buf.implementation, 'Goto Implementations')
    set('gt', vim.lsp.buf.type_definition, 'Goto T[y]pe Definitions')
    set('ge', vim.diagnostic.setqflist, 'Send Diagnostics to Qf list')
    set('gs', vim.lsp.buf.document_symbol, 'Show Document Symbols')
    set('gS', vim.lsp.buf.workspace_symbol, 'Show Workspace Symbols')
    set('<C-k>', vim.lsp.buf.signature_help, 'Signature Help', 'i')
  end,
})
