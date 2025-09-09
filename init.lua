------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Diagnostic
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--- Confirure the behavior of diagnostics in neovim
--- We want to not trigger this immediately on startup, that's why we wrap it under `vim.schedule`
vim.schedule(
  function()
    vim.diagnostic.config({
      update_in_insert = false,
      float = { source = true },
      signs = {
        priority = 9999,
        severity = {
          min = vim.diagnostic.severity.WARN,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      underline = {
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      virtual_lines = false,
      virtual_text = {
        current_line = true,
        severity = {
          min = vim.diagnostic.severity.ERROR,
          max = vim.diagnostic.severity.ERROR,
        },
      },
    })
  end
)

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Opts
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

vim.g.loaded_netrw = 1 -- Disable netrw
vim.g.loaded_netrwPlugin = 1 -- Disable netrw
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.markdown_folding = 1 -- Use folding by heading in markdown files
vim.opt.autoindent = true -- Use auto indent
vim.opt.background = 'dark'
vim.opt.backup = false
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.breakindentopt = 'list:-1' -- Add padding for lists when 'wrap' is on
vim.opt.clipboard = 'unnamed'
vim.opt.cmdheight = 1
vim.opt.colorcolumn = '+1' -- Draw colored column one step to the right of desired maximum width
vim.opt.complete = '.,w,b,kspell' -- Use spell check and don't use tags for completion
vim.opt.completeopt = 'menuone,noselect' -- Show popup even with one item and don't autoselect first
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.cursorlineopt = 'screenline,number' -- Show cursor line only screen line when wrapped
vim.opt.diffopt = 'internal,filler,closeoff,algorithm:histogram,linematch:60,indent-heuristic,vertical,context:99'
vim.opt.expandtab = true -- Convert tabs to spaces
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
vim.opt.foldlevel = 1 -- Display all folds except top ones
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'indent' -- Set 'indent' folding method
vim.opt.foldnestmax = 10 -- Create folds only for some number of nested levels
vim.opt.foldtext = ''
-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.opt.formatoptions = 'rqnl1j' -- Improve comment editing
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor'
vim.opt.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
vim.opt.incsearch = true -- Show search results while typing
vim.opt.infercase = true -- Infer letter cases for a richer built-in keyword completion
vim.opt.iskeyword = '@,48-57,_,192-255,-' -- Treat dash separated words as a word text object
vim.opt.laststatus = 0
vim.opt.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.opt.list = true -- Show helpful character indicators
vim.opt.listchars = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',') -- Special text symbols
vim.opt.mouse = 'a'
vim.opt.mousescroll = 'ver:3,hor:0'
vim.opt.number = true -- Show line numbers
vim.opt.pumheight = 10 -- Make popup menu smaller

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
vim.opt.ruler = false -- Don't show cursor position
vim.opt.scrolloff = 8
vim.opt.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit what is stored in ShaDa file
vim.opt.shiftwidth = 4 -- Use this number of spaces for indentation
vim.opt.shortmess = 'FOSWaco' -- Disable certain messages from |ins-completion-menu|
vim.opt.showcmd = false
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.sidescrolloff = 24
vim.opt.signcolumn = 'yes' -- Always show signcolumn or it would frequently shift
vim.opt.smartcase = true -- Don't ignore case when searching if pattern has upper case
vim.opt.smartindent = true -- Make indenting smart
vim.opt.spelloptions = 'camel' -- Treat parts of camelCase words as seprate words
vim.opt.splitbelow = true -- Horizontal splits will be below
vim.opt.splitright = true -- Vertical splits will be to the right
vim.opt.swapfile = false
vim.opt.switchbuf = 'usetab' -- Use already opened buffers when switching
vim.opt.tabstop = 4 -- Insert 2 spaces for a tab
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 10
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.virtualedit = 'block' -- Allow going past the end of line in visual block mode
vim.opt.wildignore:append('.DS_Store')
vim.opt.wildignorecase = true
vim.opt.wildmenu = true
vim.opt.wildmode = 'noselect:longest:lastused,full'
vim.opt.wrap = false
vim.opt.wrap = false -- Display long lines as just one line
vim.opt.writebackup = false

if vim.fn.has('nvim-0.9') == 1 then
  vim.opt.shortmess = 'CFOSWaco' -- Don't show "Scanning..." messages
  vim.opt.splitkeep = 'screen' -- Reduce scroll during window split
end

if vim.fn.has('nvim-0.10') == 1 then
  vim.opt.foldtext = '' -- Use underlying text with its highlighting
  vim.opt.termguicolors = true -- Enable gui colors (Neovim>=0.10 does this automatically)
end

if vim.fn.has('nvim-0.11') == 1 then
  vim.opt.winborder = 'double' -- Use double-line as default border
  vim.opt.completeopt = 'menuone,noselect,fuzzy,nosort' -- Use fuzzy matching for built-in completion
end

if vim.fn.has('nvim-0.12') == 1 then
  vim.opt.pummaxwidth = 100 -- Limit maximum width of popup menu
  vim.opt.completefuzzycollect = 'keyword,files,whole_line' -- Use fuzzy matching when collecting candidates
  require('vim._extui').enable({ enable = true })
  vim.cmd([[autocmd CmdlineChanged [:/\?@] call wildtrigger()]]) -- Command line autocompletion
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

-- Enable syntax highlighing if it wasn't already (as it is time consuming)
-- Don't use defer it because it affects start screen appearance
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
---------------------------------------- Autocommands
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-custom-settings', {}),
  callback = function()
    -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
    -- If don't do this on `FileType`, this keeps reappearing due to being set in
    -- filetype plugins.
    vim.cmd('setlocal formatoptions-=c formatoptions-=o')
  end,
  desc = [[Ensure proper 'formatoptions']],
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('crnvl-post-grep-events', { clear = true }),
  pattern = '*grep*',
  -- Auto open quickfix window after grep command
  command = 'cwindow',
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = vim.api.nvim_create_augroup('crnvl-checktime', { clear = true }),
  callback = function()
    -- Auto update neovim after some content has been changed due to an external process
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

-- Paste before/after linewise
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

local hues, colors = require('mini.hues'), require('mini.colors')
hues.apply_palette(hues.make_palette({
  background = vim.o.background == 'dark' and '#16161D' or '#e1e2e3',
  foreground = vim.o.background == 'dark' and '#DCD7BA' or '#2f2e2d',
  saturation = vim.o.background == 'dark' and 'lowmedium' or 'mediumhigh',
  accent = 'bg',
}))

colors
  .get_colorscheme()
  :add_terminal_colors()
  :add_cterm_attributes()
  :add_transparency({
    float = true,
    statuscolumn = true,
    statusline = false,
    tabline = true,
    winbar = true,
  })
  :apply()

for _, hl in ipairs({
  'Pmenu',
  'StatusLine',
  'StatusLineNC',
  'StatusLineTerm',
  'StatusLineTermNC',
  --
  'MiniFilesBorder',
  'MiniFilesBorderModified',
  'MiniFilesDirectory',
  'MiniFilesFile',
  'MiniFilesNormal',
  'MiniFilesTitle',
  'MiniFilesTitleFocused',
  'MiniPickBorder',
  'MiniPickBorderBusy',
  'MiniPickBorderText',
  'MiniPickCursor',
  'MiniPickIconDirectory',
  'MiniPickIconFile',
  'MiniPickHeader',
  'MiniPickNormal',
  'MiniPickPreviewLine',
  'MiniPickPreviewRegion',
  'MiniPickPrompt',
  'MiniPickPromptCaret',
  'MiniPickPromptPrefix',
}) do
  local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl, link = false })
  if is_ok then
    vim.api.nvim_set_hl(0, hl, vim.tbl_deep_extend('force', hl_def --[[@as vim.api.keyset.highlight]], { bg = 'none' }))
  end
end

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
local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)
local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
  show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(diag1, diag2) return diag1.severity > diag2.severity end)
    return show_handler(ns, bufnr, diagnostics, opts)
  end,
  hide = hide_handler,
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
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    markdown = { 'prettier', name = 'dprint' },
    json = { 'jq', name = 'dprint' },
    jsonc = { 'jq', name = 'dprint' },
    rust = { 'rustfmt' },
    toml = { name = 'dprint' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format', name = 'dprint' },
    javascript = { 'prettier', name = 'dprint' },
    typescript = { 'prettier', name = 'dprint' },
    javascriptreact = { 'prettier', name = 'dprint' },
    typescriptreact = { 'prettier', name = 'dprint' },
    yaml = { 'prettier' },
    lua = { 'stylua' },
  },
})

vim.api.nvim_create_user_command('PluginToggleFormat', function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(('%s formatting...'):format(vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
end, { nargs = 0 })
