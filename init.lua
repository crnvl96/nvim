------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Opts
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.loaded_node_provider = 0 -- Disable NodeJS support
vim.g.loaded_perl_provider = 0 -- Disable Perl support
vim.g.loaded_python3_provider = 0 -- Disable Python support
vim.g.loaded_ruby_provider = 0 -- Disable Ruby support

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.markdown_folding = 1

vim.opt.autoindent = true
vim.opt.background = 'dark'
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.breakindentopt = 'list:-1'
vim.opt.clipboard = 'unnamed'
vim.opt.cmdheight = 1
vim.opt.colorcolumn = '+1'
vim.opt.complete = '.,w,b,kspell'
vim.opt.completeopt = table.concat({
  'menuone',
  'noselect',
}, ',')
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'screenline,number'
vim.opt.diffopt = table.concat({
  'internal',
  'filler',
  'closeoff',
  'algorithm:histogram',
  'linematch:60',
  'indent-heuristic',
  'vertical',
  'context:99',
}, ',')
vim.opt.expandtab = true
vim.opt.fillchars = table.concat({
  'eob: ',
  'fold:╌',
  'horiz:═',
  'horizdown:╦',
  'horizup:╩',
  'vert:║',
  'verthoriz:╬',
  'vertleft:╣',
  'vertright:╠',
}, ',')
vim.opt.foldcolumn = '0'
vim.opt.foldlevel = 1
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'indent'
vim.opt.foldnestmax = 10
vim.opt.foldtext = ''
vim.opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.opt.formatoptions = 'rqnl1j'
vim.opt.guicursor = table.concat({
  'n-v-c-sm:block',
  'i-ci-ve:ver25',
  'r-cr-o:hor20',
  't:block-TermCursor',
}, ',')
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.infercase = true
vim.opt.iskeyword = '@,48-57,_,192-255,-'
vim.opt.laststatus = 0
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = table.concat({
  'extends:…',
  'nbsp:␣',
  'precedes:…',
  'tab:> ',
}, ',')
vim.opt.mouse = 'a'
vim.opt.mousescroll = 'ver:3,hor:0'
vim.opt.number = true
vim.opt.pumheight = 10

local function get_quickfix_items(info)
  if info.quickfix == 1 then
    return vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    return vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
end

local function format_filename(fname, limit)
  if fname == '' then return '[No Name]' end
  fname = fname:gsub('^' .. vim.env.HOME, '~')
  if #fname <= limit then
    return ('%-' .. limit .. 's'):format(fname)
  else
    return ('…%.' .. (limit - 1) .. 's'):format(fname:sub(1 - limit))
  end
end

local function format_location(lnum, col) return (lnum > 99999 and -1 or lnum), (col > 999 and -1 or col) end
local function format_type(qtype) return qtype == '' and '' or ' ' .. qtype:sub(1, 1):upper() end

function _G.qftf(info)
  local items = get_quickfix_items(info)
  local ret = {}
  local limit = 31
  for i = info.start_idx, info.end_idx do
    local entry = items[i]
    local formatted_text
    if entry.valid == 1 then
      local fname = ''
      if entry.bufnr > 0 then fname = format_filename(vim.fn.bufname(entry.bufnr), limit) end
      local lnum, col = format_location(entry.lnum, entry.col)
      local qtype = format_type(entry.type)
      formatted_text = ('%s │%5d:%-3d│%s %s'):format(fname, lnum, col, qtype, entry.text)
    else
      formatted_text = entry.text
    end
    table.insert(ret, formatted_text)
  end
  return ret
end

vim.opt.qftf = '{info -> v:lua._G.qftf(info)}'
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.scrolloff = 8
vim.opt.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.opt.shiftwidth = 4
vim.opt.shortmess = 'FOSWaco'
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.sidescrolloff = 24
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spelloptions = 'camel'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.switchbuf = 'usetab'
vim.opt.tabstop = 4
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 10
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.virtualedit = 'block'
vim.opt.wildignore:append('.DS_Store')
vim.opt.wildignorecase = true
vim.opt.wildmenu = true
vim.opt.wildmode = 'noselect:longest:lastused,full'
vim.opt.wrap = false
vim.opt.wrap = false
vim.opt.writebackup = false

if vim.fn.has('nvim-0.9') == 1 then
  vim.opt.shortmess = 'CFOSWaco'
  vim.opt.splitkeep = 'screen'
end

if vim.fn.has('nvim-0.10') == 1 then
  vim.opt.foldtext = ''
  vim.opt.termguicolors = true
end

if vim.fn.has('nvim-0.11') == 1 then
  vim.opt.winborder = 'double'
  vim.opt.completeopt = 'menuone,noselect,fuzzy,nosort'
end

if vim.fn.has('nvim-0.12') == 1 then
  vim.opt.pummaxwidth = 100
  vim.opt.completefuzzycollect = 'keyword,files,whole_line'
  require('vim._extui').enable({ enable = true })
  vim.cmd([[autocmd CmdlineChanged [:/\?@] call wildtrigger()]])
  vim.opt.wildmode = 'noselect:lastused'
  vim.opt.wildoptions = 'pum,fuzzy'
  vim.keymap.set('c', '<Up>', '<C-u><Up>')
  vim.keymap.set('c', '<Down>', '<C-u><Down>')
  vim.keymap.set('c', '<C-n>', [[cmdcomplete_info().pum_visible ? "\<C-n>" : "\<Tab>"]], { expr = true })
  vim.keymap.set('c', '<C-p>', [[cmdcomplete_info().pum_visible ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
end

if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = "rg --vimgrep --hidden -g '!.git/*'"
  vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end

if vim.fn.executable('fd') == 1 and vim.fn.executable('fzf') == 1 then
  function _G.fuzzyfindfunc(cmdarg) return vim.fn.systemlist("fd -t f -H . | fzf --filter='" .. cmdarg .. "'") end
  vim.opt.findfunc = 'v:lua._G.fuzzyfindfunc'
end

vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Autocommands
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-custom-settings', {}),
  callback = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
  desc = [[Ensure proper 'formatoptions']],
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('crnvl-post-grep-events', { clear = true }),
  pattern = '*grep*',
  command = 'cwindow',
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = vim.api.nvim_create_augroup('crnvl-checktime', { clear = true }),
  callback = function()
    if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl-highlight-on-yank', { clear = true }),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('crnvl-termoptions', { clear = true }),
  command = 'setlocal listchars= nonumber norelativenumber',
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl-last-location', { clear = true }),
  callback = function(e)
    local mark = vim.api.nvim_buf_get_mark(e.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(e.buf)
    if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('crnvl-resize', { clear = true }),
  command = 'tabdo wincmd =',
})

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Keymaps
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--- Creates a scratch, transient buffer. Ideal for quick annotations
---@return nil
local function create_scratch_buf()
  local buf_opts = {
    filetype = 'scratch',
    buftype = 'nofile',
    bufhidden = 'wipe',
    swapfile = false,
    modifiable = true,
  }
  vim.cmd('bel 10new')
  local buf = vim.api.nvim_get_current_buf()
  for name, value in pairs(buf_opts) do
    vim.api.nvim_set_option_value(name, value, { buf = buf })
  end
end

--- When sending a key command to a terminal (e.g: <C-h>) to a terminal buffer, automatically precedes it with <Esc>
---@param key? string Key command to be executed on the terminal
---@return function
local function term_send_esc(key)
  return function()
    local feed = vim.api.nvim_feedkeys
    local rep = vim.api.nvim_replace_termcodes

    local esc_termcode = rep('<C-\\><C-n>', true, true, true)

    if key then
      local key_termcode = rep(key, true, true, true)
      feed(esc_termcode .. key_termcode, 't', true)
    else
      feed(esc_termcode, 't', true)
    end
  end
end

local paste_cmd = vim.fn.has('nvim-0.12') == 1 and 'iput' or 'put'
vim.keymap.set({ 'n', 'x' }, '[p', '<Cmd>exe "' .. paste_cmd .. '! " . v:register<CR>', { desc = 'Paste Above' })
vim.keymap.set({ 'n', 'x' }, ']p', '<Cmd>exe "' .. paste_cmd .. ' "  . v:register<CR>', { desc = 'Paste Below' })

vim.keymap.set({ 'n', 'x' }, 'Y', 'yg_')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>p', '"+p')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>P', '"+P')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>y', '"+y')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>Y', '"+yg_')
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'i', 'x' }, '<C-S>', '<Esc><Cmd>silent! update | redraw<CR>')
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<Leader>s', create_scratch_buf)

vim.keymap.set('x', 'p', 'P')
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

vim.keymap.set({ 'n', 't' }, '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set({ 'n', 't' }, '<C-Right>', '<Cmd>vertical resize +20<CR>')

vim.keymap.set('t', '<C-h>', term_send_esc('<C-h>'))
vim.keymap.set('t', '<C-j>', term_send_esc('<C-j>'))
vim.keymap.set('t', '<C-k>', term_send_esc('<C-k>'))
vim.keymap.set('t', '<C-l>', term_send_esc('<C-l>'))
vim.keymap.set('t', '<C-e>', term_send_esc())

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Path
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local node_version_cmd = "mise ls --cd ~ | grep '^node' | grep '22\\.' | head -n 1 | awk '{print $2}'"
local function node_bin(v) return os.getenv('HOME') .. '/.local/share/mise/installs/node/' .. v .. '/bin/' end

local version = vim.fn.system(node_version_cmd):gsub('\n', '')
if version == '' then
  vim.notify('Could not determine Node.js version', vim.log.levels.WARN)
else
  local bin = node_bin(version)
  vim.g.node_host_prog = bin .. 'node'
  vim.env.PATH = bin .. ':' .. vim.env.PATH
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Diagnostic
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

vim.diagnostic.config({
  update_in_insert = false, -- Update diagnostics only on `InserLeave`
  float = {
    source = true, -- Show the diagnostic source on the float window
  },
  signs = {
    priority = 9999, -- Ensure these are visible on the signcolumn
    severity = { -- Only show signs for diagnostics matching this severity range
      min = vim.diagnostic.severity.WARN,
      max = vim.diagnostic.severity.ERROR,
    },
  },
  underline = { -- Only show underline for diagnostics matching this severity range
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
  },
  virtual_lines = false,
  virtual_text = {
    current_line = true, -- Show virtual text only for the diagnostic(s) of the cursor line
    severity = { -- Only show virtual text for diagnostics matching this severity range
      min = vim.diagnostic.severity.ERROR,
      max = vim.diagnostic.severity.ERROR,
    },
  },
})

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Package manager
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
local minipath = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(minipath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    minipath,
  })
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup()

MiniDeps.add({ name = 'mini.nvim' })

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Mini
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

vim.cmd.colorscheme('ham')

require('mini.doc').setup()
require('mini.icons').setup()
require('mini.misc').setup()
require('mini.extra').setup()
require('mini.keymap').setup()
require('mini.align').setup()

require('mini.ai').setup({
  custom_textobjects = {
    g = MiniExtra.gen_ai_spec.buffer(),
    f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
  },
  silent = true,
  search_method = 'cover',
  mappings = {
    around_next = '',
    inside_next = '',
    around_last = '',
    inside_last = '',
  },
})

require('mini.files').setup({
  mappings = {
    show_help = '?',
    go_in = '',
    go_out = '',
    go_in_plus = '<CR>',
    go_out_plus = '-',
  },
})

--- Open MiniFiles at the current directory
---@return nil
local function open_file_explorer()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')
  if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
end

vim.keymap.set('n', '-', open_file_explorer)

require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')

require('mini.extra').setup()
require('mini.pick').setup({
  options = { use_cache = true },
  window = { prompt_prefix = '  ' },
})

vim.keymap.set('n', '<Leader>f', '<Cmd>Pick files<CR>')
vim.keymap.set('n', '<Leader>g', '<Cmd>Pick grep_live<CR>')
vim.keymap.set('n', '<Leader>l', '<Cmd>Pick buf_lines scope="current"<CR>')
vim.keymap.set('n', '<Leader>b', '<Cmd>Pick buffers include_current=false<CR>')

vim.ui.select = require('mini.pick').ui_select

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Plugins
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

MiniDeps.add({ source = 'tpope/vim-sleuth' })
MiniDeps.add({ source = 'tpope/vim-fugitive' })
MiniDeps.add({ source = 'wincent/ferret' })

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Treesitter
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'main',
  hooks = {
    post_checkout = function() vim.cmd('TSUpdate') end,
  },
})

MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter-textobjects',
  checkout = 'main',
})

-- stylua: ignore
local ensure_installed = { 'c', 'lua', 'vimdoc', 'query', 'markdown', 'markdown_inline', 'javascript', 'typescript', 'tsx', 'jsx',
  'python', 'rust', 'ron', 'bash', 'gitcommit', 'html', 'hyprlang', 'json', 'json5', 'jsonc',
  'rasi', 'regex', 'scss', 'toml', 'vim', 'yaml', }

local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
if #to_install > 0 then require('nvim-treesitter').install(to_install) end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl-treesitter', { clear = true }),
  pattern = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable(),
  callback = function(e) vim.treesitter.start(e.buf) end,
})

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Lsp config
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

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
    local str = 'AEIOUaeiou\'".:'
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

  if client:supports_method(methods.textDocument_documentColor) then
    vim.keymap.set({ 'n', 'x' }, 'gC', function() vim.lsp.document_color.color_presentation() end)
  end

  vim.keymap.set(
    'n',
    '[e',
    function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end
  )
  vim.keymap.set('n', ']e', function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end)
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
  vim.keymap.set('n', 'gS', vim.lsp.buf.workspace_symbol, { buffer = buf })
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = buf })
end

-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
local show_handler = vim.diagnostic.handlers.virtual_text.show -- Get the original show handler
assert(show_handler) -- Validate that handler exists
local hide_handler = vim.diagnostic.handlers.virtual_text.hide -- Get the original hide handler
vim.diagnostic.handlers.virtual_text = { -- Set the virtual text of diagnostics
  show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(diag1, diag2) return diag1.severity > diag2.severity end) -- Sort the diagnostics by severity
    return show_handler(ns, bufnr, diagnostics, opts) -- Overwrite the original handler
  end,
  hide = hide_handler, -- Use the original handler
}

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
  group = vim.api.nvim_create_augroup('crnvl-lsp', { clear = true }),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    on_attach(client, e.buf)
  end,
})

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Conform.nvim
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

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
    lua = { 'stylua' },
    yaml = { 'prettier' },
    json = { 'jq', name = 'dprint' },
    jsonc = { 'jq', name = 'dprint' },
    rust = { 'rustfmt' },
    toml = { name = 'dprint' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format', name = 'dprint' },
    markdown = { 'prettier', name = 'dprint' },
    javascript = { 'prettier', name = 'dprint' },
    typescript = { 'prettier', name = 'dprint' },
    javascriptreact = { 'prettier', name = 'dprint' },
    typescriptreact = { 'prettier', name = 'dprint' },
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
  },
})

vim.api.nvim_create_user_command('PluginToggleFormat', function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(('%s formatting...'):format(vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
end, { nargs = 0 })

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Grug-far.nvim
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

MiniDeps.add('MagicDuck/grug-far.nvim')
require('grug-far').setup()
