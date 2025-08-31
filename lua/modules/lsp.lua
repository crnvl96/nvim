local U = require('utils')

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
  prohibited = { 'rust_analyzer' },
}

local allowed = {}
for _, file in ipairs(servers.all) do
  local server_name = vim.fn.fnamemodify(file, ':t:r')
  local is_server_allowed = not vim.tbl_contains(servers.prohibited, server_name)
  if is_server_allowed then
    table.insert(allowed, server_name)
    local content = assert(loadfile(file))
    vim.lsp.config(server_name, content())
  end
end

vim.lsp.enable(allowed)

U.augroup('crnvl-lspattach', function(g)
  U.aucmd('LspAttach', {
    group = g,
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end

      U.lspmap(e.buf, 'E', vim.diagnostic.open_float, 'Show Error')
      U.lspmap(e.buf, 'K', vim.lsp.buf.hover, 'Hover')
      U.lspmap(e.buf, 'ga', vim.lsp.buf.code_action, 'Code Actions')
      U.lspmap(e.buf, 'gn', vim.lsp.buf.rename, 'Rename Symbol')
      U.lspmap(e.buf, 'gd', vim.lsp.buf.definition, 'Goto Definition')
      U.lspmap(e.buf, 'gD', vim.lsp.buf.declaration, 'Goto Declaration')
      U.lspmap(e.buf, 'gr', vim.lsp.buf.references, 'Goto References')
      U.lspmap(e.buf, 'gi', vim.lsp.buf.implementation, 'Goto Implementations')
      U.lspmap(e.buf, 'gt', vim.lsp.buf.type_definition, 'Goto T[y]pe Definitions')
      U.lspmap(e.buf, 'ge', vim.diagnostic.setqflist, 'Send Diagnostics to Qf list')
      U.lspmap(e.buf, 'gs', vim.lsp.buf.document_symbol, 'Show Document Symbols')
      U.lspmap(e.buf, 'gS', vim.lsp.buf.workspace_symbol, 'Show Workspace Symbols')
      U.lspmap(e.buf, '<C-k>', vim.lsp.buf.signature_help, 'Signature Help', 'i')
    end,
  })
end)
