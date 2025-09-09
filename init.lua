require('qtft')

vim.schedule(
  function()
    vim.diagnostic.config({
      update_in_insert = false,
      float = { source = true },
      signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
      underline = { severity = { min = 'HINT', max = 'ERROR' } },
      virtual_lines = false,
      virtual_text = { current_line = true, severity = { min = 'ERROR', max = 'ERROR' } },
    })
  end
)

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.markdown_folding = 1 -- Use folding by heading in markdown files

vim.opt.background = 'dark'
vim.opt.backup = false
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.breakindentopt = 'list:-1' -- Add padding for lists when 'wrap' is on
vim.opt.clipboard = 'unnamed'
vim.opt.cmdheight = 1
vim.opt.colorcolumn = '+1' -- Draw colored column one step to the right of desired maximum width
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.cursorlineopt = 'screenline,number' -- Show cursor line only screen line when wrapped
vim.opt.diffopt = 'internal,filler,closeoff,algorithm:histogram,linematch:60,indent-heuristic,vertical,context:99'
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
vim.opt.foldlevelstart = 99
vim.opt.foldtext = ''
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor'
vim.opt.laststatus = 0
vim.opt.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.opt.list = true -- Show helpful character indicators
vim.opt.listchars = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',') -- Special text symbols
vim.opt.mouse = 'a'
vim.opt.mousescroll = 'ver:3,hor:0'
vim.opt.number = true -- Show line numbers
vim.opt.pumheight = 10 -- Make popup menu smaller
vim.opt.qftf = '{info -> v:lua._G.qftf(info)}'
vim.opt.relativenumber = true
vim.opt.ruler = false -- Don't show cursor position
vim.opt.scrolloff = 8
vim.opt.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit what is stored in ShaDa file
vim.opt.shortmess = 'FOSWaco' -- Disable certain messages from |ins-completion-menu|
vim.opt.showcmd = false
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.sidescrolloff = 24
vim.opt.signcolumn = 'yes' -- Always show signcolumn or it would frequently shift
vim.opt.splitbelow = true -- Horizontal splits will be below
vim.opt.splitright = true -- Vertical splits will be to the right
vim.opt.swapfile = false
vim.opt.switchbuf = 'usetab' -- Use already opened buffers when switching
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 10
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.wildignore:append('.DS_Store')
vim.opt.wildignorecase = true
vim.opt.wildmenu = true
vim.opt.wildmode = 'noselect:longest:lastused,full'
vim.opt.wrap = false
vim.opt.wrap = false -- Display long lines as just one line
vim.opt.writebackup = false
vim.opt.autoindent = true -- Use auto indent
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.formatoptions = 'rqnl1j' -- Improve comment editing
vim.opt.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
vim.opt.incsearch = true -- Show search results while typing
vim.opt.infercase = true -- Infer letter cases for a richer built-in keyword completion
vim.opt.shiftwidth = 4 -- Use this number of spaces for indentation
vim.opt.smartcase = true -- Don't ignore case when searching if pattern has upper case
vim.opt.smartindent = true -- Make indenting smart
vim.opt.tabstop = 4 -- Insert 2 spaces for a tab
vim.opt.virtualedit = 'block' -- Allow going past the end of line in visual block mode
vim.opt.iskeyword = '@,48-57,_,192-255,-' -- Treat dash separated words as a word text object
vim.opt.completeopt = 'menuone,noselect' -- Show popup even with one item and don't autoselect first
vim.opt.complete = '.,w,b,kspell' -- Use spell check and don't use tags for completion
vim.opt.spelloptions = 'camel' -- Treat parts of camelCase words as seprate words
vim.opt.foldmethod = 'indent' -- Set 'indent' folding method
vim.opt.foldlevel = 1 -- Display all folds except top ones
vim.opt.foldnestmax = 10 -- Create folds only for some number of nested levels

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

-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

if vim.fn.has('nvim-0.10') == 1 then
  vim.opt.foldtext = '' -- Use underlying text with its highlighting
end

if vim.fn.has('nvim-0.11') == 1 then
  vim.opt.completeopt = 'menuone,noselect,fuzzy,nosort' -- Use fuzzy matching for built-in completion
end

if vim.fn.has('nvim-0.9') == 1 then
  vim.opt.shortmess = 'CFOSWaco' -- Don't show "Scanning..." messages
  vim.opt.splitkeep = 'screen' -- Reduce scroll during window split
end

if vim.fn.has('nvim-0.10') == 0 then
  vim.opt.termguicolors = true -- Enable gui colors (Neovim>=0.10 does this automatically)
end

if vim.fn.has('nvim-0.11') == 1 then
  vim.opt.winborder = 'double' -- Use double-line as default border
end

if vim.fn.has('nvim-0.12') == 1 then
  vim.opt.pummaxwidth = 100 -- Limit maximum width of popup menu
  vim.opt.completefuzzycollect = 'keyword,files,whole_line' -- Use fuzzy matching when collecting candidates
  require('vim._extui').enable({ enable = true })
  -- Command line autocompletion
  vim.cmd([[autocmd CmdlineChanged [:/\?@] call wildtrigger()]])
  vim.opt.wildmode = 'noselect:lastused'
  vim.opt.wildoptions = 'pum,fuzzy'
  vim.keymap.set('c', '<Up>', '<C-u><Up>')
  vim.keymap.set('c', '<Down>', '<C-u><Down>')
  -- TODO: Make this part of 'mini.keymap'
  vim.keymap.set('c', '<Tab>', [[cmdcomplete_info().pum_visible ? "\<C-n>" : "\<Tab>"]], { expr = true })
  vim.keymap.set('c', '<S-Tab>', [[cmdcomplete_info().pum_visible ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
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
local cmd = vim.fn.has('nvim-0.12') == 1 and 'iput' or 'put'
vim.keymap.set({ 'n', 'x' }, '[p', '<Cmd>exe "' .. cmd .. '! " . v:register<CR>', { desc = 'Paste Above' })
vim.keymap.set({ 'n', 'x' }, ']p', '<Cmd>exe "' .. cmd .. ' "  . v:register<CR>', { desc = 'Paste Below' })

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

vim.keymap.set('n', '<leader>b', ':b<space>')

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

local minipath = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

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

--- Open MiniFiles at the current directory
---@return nil
local function open_file_explorer()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')
  if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
end

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

local hues, colors = require('mini.hues'), require('mini.colors')
hues.apply_palette(hues.make_palette({
  background = vim.o.background == 'dark' and '#212223' or '#e1e2e3',
  foreground = vim.o.background == 'dark' and '#ed8796' or '#2f2e2d',
  saturation = vim.o.background == 'dark' and 'lowmedium' or 'mediumhigh',
  n_hues = 8,
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

for _, hl in ipairs({ 'Pmenu', 'StatusLine', 'StatusLineNC', 'StatusLineTerm', 'StatusLineTermNC' }) do
  local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl, link = false })
  if is_ok then
    vim.api.nvim_set_hl(0, hl, vim.tbl_deep_extend('force', hl_def --[[@as vim.api.keyset.highlight]], { bg = 'none' }))
  end
end

for _, hl in ipairs({
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
    B = MiniExtra.gen_ai_spec.buffer(),
    F = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
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

vim.keymap.set('n', '-', open_file_explorer)

---@TODO: Maybe later we don't need anymore these references to `blink`
require('mini.keymap').map_multistep({ 'i', 'c' }, '<C-n>', { 'blink_next', 'pmenu_next' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<C-p>', { 'blink_prev', 'pmenu_prev' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<Tab>', { 'blink_next', 'pmenu_next' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<S-Tab>', { 'blink_prev', 'pmenu_prev' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<CR>', { 'blink_accept', 'pmenu_accept' })
require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')

---@TODO: Under analysis. We may get rid of this block of code
-- require('mini.keymap').map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
-- require('mini.keymap').map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')

MiniDeps.add({ source = 'tpope/vim-sleuth' })
MiniDeps.add({ source = 'tpope/vim-fugitive' })

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

local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
if #to_install > 0 then require('nvim-treesitter').install(to_install) end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl-treesitter', { clear = true }),
  pattern = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable(),
  callback = function(e) vim.treesitter.start(e.buf) end,
})

---@TODO: Maybe in the future we completely remove  the blink plugin
-- local function build_blink(p)
--   vim.notify('Building ' .. p.name, vim.log.levels.INFO)
--   local cmd = { 'cargo', '+nightly', 'build', '--release' }
--   local opts = { cwd = p.path }
--   local obj = vim.system(cmd, opts):wait()
--   if obj.code == 0 then
--     vim.notify('Done!', vim.log.levels.INFO)
--   else
--     vim.notify('A Fail occurred!', vim.log.levels.ERROR)
--   end
-- end
--
-- MiniDeps.add({
--   source = 'Saghen/blink.cmp',
--   hooks = {
--     post_install = build_blink,
--     post_checkout = build_blink,
--   },
-- })
--
-- require('blink.cmp').setup({
--   appearance = { nerd_font_variant = 'mono' },
--   keymap = {
--     preset = 'default',
--     ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings' },
--   },
--   cmdline = {
--     keymap = { preset = 'inherit' },
--     completion = {
--       list = {
--         selection = {
--           preselect = false,
--           auto_insert = true,
--         },
--       },
--       menu = { auto_show = true },
--       ghost_text = { enabled = true },
--     },
--   },
--   completion = {
--     list = {
--       selection = {
--         preselect = false,
--         auto_insert = true,
--       },
--     },
--     documentation = { auto_show = true },
--     menu = {
--       scrollbar = false,
--       draw = {
--         columns = {
--           { 'kind_icon' },
--           { 'label', 'label_description', 'source_name', gap = 1 },
--         },
--         components = {
--           kind_icon = {
--             text = function(ctx)
--               if ctx.source_id == 'cmdline' then return end
--               return ctx.kind_icon .. ctx.icon_gap
--             end,
--           },
--           source_name = {
--             text = function(ctx)
--               if ctx.source_id == 'cmdline' then return end
--               return ctx.source_name:sub(1, 4)
--             end,
--           },
--         },
--       },
--     },
--   },
-- })

local function build_fff(p)
  vim.notify('Building ' .. p.name, vim.log.levels.INFO)
  local cmd = { 'cargo', '+nightly', 'build', '--release' }
  local opts = { cwd = p.path }
  local obj = vim.system(cmd, opts):wait()
  if obj.code == 0 then
    vim.notify('Done!', vim.log.levels.INFO)
  else
    vim.notify('A Fail occurred!', vim.log.levels.ERROR)
  end
end

MiniDeps.add({
  source = 'dmtrKovalenko/fff.nvim',
  hooks = {
    post_install = build_fff,
    post_checkout = build_fff,
  },
})

require('fff').setup({
  prompt = '🪿 ',
  title = 'FFFiles',
  layout = {
    height = 0.4,
    width = 0.4,
  },
  preview = { enabled = false },
})

vim.keymap.set('n', '<Leader>f', require('fff').find_files)

MiniDeps.add({
  source = 'mrcjkb/rustaceanvim',
  version = 'v6.9.1',
})

vim.g.rustaceanvim = {
  server = {
    on_attach = function(_, buf)
      vim.keymap.set('n', 'ga', function() vim.cmd.RustLsp('codeAction') end, { buffer = buf })
    end,
    capabilities = {
      general = {
        positionEncodings = { 'utf-16' },
      },
    },
    default_settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        checkOnSave = false, -- Remove clippy lints for Rust due to bacon
        diagnostics = { enable = false }, -- Disable diagnostics due to bacon
        procMacro = {
          enable = true,
          ignored = {
            ['async-trait'] = { 'async_trait' },
            ['napi-derive'] = { 'napi' },
            ['async-recursion'] = { 'async_recursion' },
          },
        },
        files = {
          excludeDirs = {
            '.direnv',
            '.git',
            '.github',
            '.gitlab',
            'bin',
            'node_modules',
            'target',
            'venv',
            '.venv',
          },
        },
      },
    },
  },
}

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
    local str = 'abcdefghijklmnopqrstuvwxyz\'".:'
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

    vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { buffer = buf })
  end

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

MiniDeps.add({ source = 'MagicDuck/grug-far.nvim' })
require('grug-far').setup({
  transient = true,
  disableBufferLineNumbers = false,
})

vim.keymap.set('n', '<leader>g', '<Cmd>GrugFar<CR>')
vim.keymap.set('n', '<leader>l', function() require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } }) end)
vim.keymap.set('v', '<leader>l', '<Cmd>GrugFarWithin<CR>')
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('grug-far-keybindings', { clear = true }),
  pattern = { 'grug-far' },
  callback = function()
    vim.keymap.set('n', '<C-enter>', function()
      require('grug-far').get_instance(0):open_location()
      require('grug-far').get_instance(0):close()
    end, { buffer = true })
  end,
})
