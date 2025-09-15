MiniDeps.add({ source = 'b0o/SchemaStore.nvim' })
MiniDeps.add({ source = 'neovim/nvim-lspconfig' })

local files = os.getenv('HOME') .. '/.config/nvim/lsp/*.lua'
local methods = vim.lsp.protocol.Methods

--- Correctly retrieve the lsp server config
---@param file string name of the lsp server
local function get_server_config(file)
  local server = vim.fn.fnamemodify(file, ':t:r')
  local content = assert(loadfile(file))
  vim.lsp.config(server, vim.tbl_deep_extend('force', {}, content() or {}))
  return server
end

--- Sort vim diagnostics by severity
---@param a vim.Diagnostic vim diagnostic element
---@param b vim.Diagnostic vim diagnostic element
local function sort_by_severity(a, b) return a.severity > b.severity end

local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)

--- Display disgnostics for the given namespace and buffer
---@param ns integer Diagnostic namespae
---@param bufnr integer Buffer number
---@param diagnostics vim.Diagnostic[] The diagnostics to display
---@param opts vim.diagnostic.OptsResolved Display options
local function show(ns, bufnr, diagnostics, opts)
  table.sort(diagnostics, sort_by_severity)
  return show_handler(ns, bufnr, diagnostics, opts)
end

--- Function that is called when an lsp client is attached to a buffer
---@param client vim.lsp.Client lsp Client
---@param buf integer target buffer
local function on_attach(client, buf)
  --- Get the options for navigating error diagnostics
  ---@param count 1|-1 direction of the navigation (fw/bw)
  local function err_diag_opts(count) return { count = count, severity = vim.diagnostic.severity.ERROR } end

  vim.keymap.set('n', '[e', function() vim.diagnostic.jump(err_diag_opts(-1)) end)
  vim.keymap.set('n', ']e', function() vim.diagnostic.jump(err_diag_opts(1)) end)
  vim.keymap.set('n', 'E', vim.diagnostic.open_float, { buffer = buf })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buf })
  vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, { buffer = buf })
  vim.keymap.set('n', 'gn', vim.lsp.buf.rename, { buffer = buf })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = buf })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = buf, nowait = true })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = buf })
  vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { buffer = buf })
  vim.keymap.set('n', 'ge', vim.diagnostic.setqflist, { buffer = buf })
  vim.keymap.set('n', 'gs', vim.lsp.buf.document_symbol, { buffer = buf })
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = buf })
end

local server_configs = vim.iter(vim.fn.glob(files, true, true)):map(get_server_config):totable()
vim.lsp.enable(server_configs)

local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = { show = show, hide = hide_handler }

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover({
    max_height = math.floor(vim.o.lines * 0.5),
    max_width = math.floor(vim.o.columns * 0.4),
  })
end

local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
  return signature_help({
    max_height = math.floor(vim.o.lines * 0.5),
    max_width = math.floor(vim.o.columns * 0.4),
  })
end

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
