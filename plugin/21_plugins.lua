MiniDeps.add({ source = 'tpope/vim-fugitive' })

MiniDeps.add({ source = 'MagicDuck/grug-far.nvim' })

require('grug-far').setup()

MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'main',
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

local ensure_installed = {
  'c',
  'lua',
  'vimdoc',
  'query',
  'markdown',
  'markdown_inline',
  'javascript',
  'typescript',
  'tsx',
  'jsx',
  'python',
  'rust',
  'ron',
  'bash',
  'gitcommit',
  'html',
  'hyprlang',
  'json',
  'json5',
  'jsonc',
  'rasi',
  'regex',
  'scss',
  'toml',
  'vim',
  'yaml',
}

--- Check if a specific lang parser is already installed
---@param lang string the lang to check
---@return boolean
local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
if #to_install > 0 then require('nvim-treesitter').install(to_install) end

vim.api.nvim_create_autocmd('FileType', {
  pattern = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable(),
  callback = function(e) vim.treesitter.start(e.buf) end,
})

MiniDeps.add({ source = 'b0o/SchemaStore.nvim' })
MiniDeps.add({ source = 'neovim/nvim-lspconfig' })

local files = os.getenv('HOME') .. '/.config/nvim/lsp/*.lua'

local methods = vim.lsp.protocol.Methods

local server_configs = vim
  .iter(vim.fn.glob(files, true, true))
  :map(function(file)
    local server = vim.fn.fnamemodify(file, ':t:r')
    local content = assert(loadfile(file))
    vim.lsp.config(server, vim.tbl_deep_extend('force', {}, content() or {}))
    return server
  end)
  :totable()

vim.lsp.enable(server_configs)

local function on_attach(client, buf)
  if client:supports_method('textDocument/completion') then
    local str = 'AEIOUaeiou\'".:-_'
    local chars = { str:match((str:gsub('.', '(.)'))) }
    client.server_capabilities.completionProvider.triggerCharacters = chars
    vim.lsp.completion.enable(true, client.id, buf, {
      autotrigger = true,
      convert = function(item)
        local labelDetails = item.labelDetails
        local description = labelDetails and labelDetails.description or item.detail
        local menu = description and description or ''
        return {
          menu = menu,
        }
      end,
    })
    vim.keymap.set('i', '<C-n>', vim.lsp.completion.get, { buffer = buf })
  end

  --- Get the options for navigating error diagnostics
  ---@param count 1|-1 direction of the navigation (fw/bw)
  ---@return {count: 1|-1, severity: vim.Diagnostic}
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

local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)

local hide_handler = vim.diagnostic.handlers.virtual_text.hide

--- Sort vim diagnostics by severity
---@param a vim.Diagnostic vim diagnostic element
---@param b vim.Diagnostic vim diagnostic element
---@return boolean
local function sort_by_severity(a, b) return a.severity > b.severity end

--- Display disgnostics for the given namespace and buffer
---@param ns integer Diagnostic namespae
---@param bufnr integer Buffer number
---@param diagnostics vim.Diagnostic[] The diagnostics to display
---@param opts vim.diagnostic.OptsResolved Display options
local function show(ns, bufnr, diagnostics, opts)
  table.sort(diagnostics, sort_by_severity)
  return show_handler(ns, bufnr, diagnostics, opts)
end

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

MiniDeps.add({ source = 'stevearc/conform.nvim' })

vim.g.autoformat = true
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup({
  notify_on_error = true,
  format_on_save = function()
    if not vim.g.autoformat then return nil end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  formatters = { prettier = { require_cwd = true } },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    javascript = { 'prettier', name = 'dprint' },
    javascriptreact = { 'prettier', name = 'dprint' },
    typescript = { 'prettier', name = 'dprint' },
    typescriptreact = { 'prettier', name = 'dprint' },
    json = { name = 'dprint' },
    jsonc = { name = 'dprint' },
    lua = { 'stylua' },
    markdown = { name = 'dprint' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format', name = 'dprint' },
    rust = { lsp_format = 'prefer' },
    go = { lsp_format = 'prefer' },
    toml = { name = 'dprint' },
    yaml = { lsp_format = 'prefer' },
  },
})

vim.api.nvim_create_user_command('PluginToggleFormat', function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(('%s formatting...'):format(vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
end, { nargs = 0 })
