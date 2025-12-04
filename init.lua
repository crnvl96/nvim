local mini_path = vim.fn.stdpath 'data' .. '/site/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'
  local origin = 'https://github.com/nvim-mini/mini.nvim'
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', origin, mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd 'packadd mini.nvim | helptags ALL'
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

require('mini.deps').setup()

local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24.11.0/bin'
vim.g.node_host_prog = node_bin .. '/node'
vim.env.PATH = node_bin .. ':' .. vim.env.PATH

vim.cmd.colorscheme 'miniautumn'

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:1,hor:2'
vim.o.undofile = true
vim.o.clipboard = 'unnamedplus'
vim.o.swapfile = false
vim.o.breakindent = true
vim.o.cursorline = true
vim.o.linebreak = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.winborder = 'single'
vim.o.wrap = false
vim.o.scrolloff = 8
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.virtualedit = 'block'
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'

vim.cmd 'filetype plugin indent on'
if vim.fn.exists 'syntax_on' ~= 1 then vim.cmd 'syntax enable' end

local map = function(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, opts) end
local nmap = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc }) end
local nmap_leader = function(suffix, rhs, desc) vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc }) end
local xmap_leader = function(suffix, rhs, desc) vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc }) end

nmap('<C-d>', '<C-d>zz', 'Scroll down and center')
nmap('<C-u>', '<C-u>zz', 'Scroll up and center')

map('', 'H', '^')
map('', 'L', '$')

nmap('n', 'nzz', '')
nmap('N', 'Nzz', '')
nmap('*', '*zz', '')
nmap('#', '#zz', '')
nmap('g*', 'g*zz', '')

map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

map('n', '<C-h>', '<C-w>h', { desc = 'Focus on left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Focus on below window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Focus on above window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Focus on right window' })
map('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
map('n', '<C-Down>', '<Cmd>resize -5<CR>')
map('n', '<C-Up>', '<Cmd>resize +5<CR>')
map('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')

map('v', 'p', 'P')

nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>', 'Delete')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>', 'Delete!')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', 'Wipeout')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout!')

local explore_quickfix = function()
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.fn.getwininfo(win_id)[1].quickfix == 1 then return vim.cmd 'cclose' end
  end
  vim.cmd 'copen'
end

nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>', 'Directory')
nmap_leader('ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', 'File directory')
nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>', 'init.lua')
nmap_leader('ex', explore_quickfix, 'Quickfix')

nmap_leader("f'", '<Cmd>Pick resume<CR>', 'Resume')
nmap_leader('fb', '<Cmd>Pick buffers<CR>', 'Buffers')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="all"<CR>', 'Diagnostic workspace')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
nmap_leader('ff', '<Cmd>Pick files<CR>', 'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
nmap_leader('fh', '<Cmd>Pick help<CR>', 'Help tags')
nmap_leader('fH', '<Cmd>Pick hl_groups<CR>', 'Highlight groups')
nmap_leader('fl', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (buf)')
nmap_leader('fo', '<Cmd>Pick oldfiles<CR>', 'Oldfiles')

nmap_leader('gg', ':Git<space>', 'Git')

nmap_leader('hh', '<Cmd>noh<CR>', 'Clear Highlights')
nmap_leader('hs', '<Esc>:noh<CR>:w<CR>', 'Save buffer')

nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'Actions')
nmap_leader('ld', '<Cmd>Pick lsp scope="definition"<CR>', 'Source definition')
nmap_leader('le', '<Cmd>lua vim.diagnostic.open_float()<CR>', 'Diagnostic popup')
nmap_leader('lf', '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>', 'Format')
xmap_leader('lf', '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>', 'Format selection')
nmap_leader('lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', 'Hover')
nmap_leader('li', '<Cmd>Pick lsp scope="implementation"<CR>', 'Implementation')
nmap_leader('ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', 'Rename')
nmap_leader('lr', '<Cmd>Pick lsp scope="references"<CR>', 'References')
nmap_leader('lS', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace')
nmap_leader('ly', '<CmdPick lsp scope="type_definition"<CR>', 'Type definition')
nmap_leader('ls', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols document')

nmap_leader('wh', '<C-w>h', 'Split window vertically')
nmap_leader('wv', '<C-w>v', 'Split window horizontally')
nmap_leader('wc', '<C-w>c', 'Close current window')
nmap_leader('wo', '<C-w>o', 'Close other windows')
nmap_leader('wH', '<C-w>H', 'Move window to the left')
nmap_leader('wJ', '<C-w>J', 'Move window to bottom')
nmap_leader('wK', '<C-w>K', 'Move window to top')
nmap_leader('wL', '<C-w>L', 'Move window to the right')

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-after-yank', {}),
  callback = function() vim.highlight.on_yank() end,
})

MiniDeps.later(
  function()
    vim.diagnostic.config {
      signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
      underline = { severity = { min = 'HINT', max = 'ERROR' } },
      virtual_text = { current_line = true, severity = { min = 'ERROR', max = 'ERROR' } },
      virtual_lines = false,
      update_in_insert = false,
    }
  end
)

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function() require('mini.extra').setup() end)
later(function() require('mini.bufremove').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.jump').setup() end)
later(function() require('mini.move').setup() end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.splitjoin').setup() end)
later(function() add 'tpope/vim-fugitive' end)

now(function()
  require('mini.misc').setup()
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
end)

later(function()
  local ai = require 'mini.ai'
  ai.setup {
    custom_textobjects = {
      b = MiniExtra.gen_ai_spec.buffer(),
      f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
    },
    search_method = 'cover',
  }
end)

later(function()
  local miniclue = require 'mini.clue'
  miniclue.setup {
    clues = {
      { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<Leader>e', desc = '+Explore/Edit' },
      { mode = 'n', keys = '<Leader>f', desc = '+Find' },
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>l', desc = '+Language' },
      { mode = 'n', keys = '<Leader>w', desc = '+Window' },
      { mode = 'n', keys = '<Leader>h', desc = '+Misc' },
      { mode = 'x', keys = '<Leader>g', desc = '+Git' },
      { mode = 'x', keys = '<Leader>l', desc = '+Language' },
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows { submode_resize = true },
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = '<Localleader>' },
      { mode = 'x', keys = '<Localleader>' },
      { mode = 'n', keys = '\\' },
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },
    window = {
      config = { width = 'auto' },
      delay = 500,
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    },
  }
end)

later(function()
  local process_items_opts = { kind_priority = { Text = -1, Snippet = -1 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end
  require('mini.completion').setup {
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = process_items,
    },
  }
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lspattach', {}),
    callback = function(ev) vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
  })
  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

later(
  function()
    require('mini.files').setup {
      mappings = {
        go_in = '',
        go_in_plus = '<CR>',
        go_out = '',
        go_out_plus = '-',
      },
      windows = {
        preview = true,
        width_focus = 50,
        width_nofocus = 15,
        width_preview = 80,
      },
    }
  end
)

later(
  function()
    require('mini.jump2d').setup {
      spotter = require('mini.jump2d').gen_spotter.pattern '[^%s%p]+',
      view = { dim = true, n_steps_ahead = 2 },
      mappings = {
        start_jumping = 's',
      },
    }
  end
)

later(function()
  require('mini.keymap').setup()
  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<C-n>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<C-p>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept' })
  local mode = { 'i', 'c', 'x', 's' }
  require('mini.keymap').map_combo(mode, 'jk', '<BS><BS><Esc>')
  require('mini.keymap').map_combo(mode, 'kj', '<BS><BS><Esc>')
  require('mini.keymap').map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
  require('mini.keymap').map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
end)

now(function()
  add {
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd 'TSUpdate' end },
  }
  add {
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    checkout = 'main',
  }
  local languages = {
    'html',
    'css',
    'go',
    'python',
    'diff',
    'bash',
    'json',
    'regex',
    'lisp',
    'toml',
    'yaml',
    'markdown',
    'javascript',
    'typescript',
    'tsx',
    'lua',
    'vimdoc',
  }
  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('crnvl96-nvim-treesitter', {}),
    pattern = filetypes,
    callback = function(ev) vim.treesitter.start(ev.buf) end,
  })
end)

now(function()
  add 'neovim/nvim-lspconfig'
  vim.lsp.enable {
    'eslint',
    'gopls',
    'lua_ls',
    'pyright',
    'ruff',
    'ts_ls',
  }
end)

later(function()
  add 'stevearc/conform.nvim'
  vim.g.autoformat = true
  require('conform').setup {
    notify_on_error = false,
    notify_no_formatters = false,
    default_format_opts = {
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },
    formatters = {
      stylua = { require_cwd = true },
      prettier = { require_cwd = false },
      injected = { ignore_errors = true },
    },
    formatters_by_ft = {
      go = { 'gofumpt' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier', 'injected', timeout_ms = 1500 },
      css = { 'prettier' },
      scss = { 'prettier' },
      yaml = { 'prettier' },
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
    },
    format_on_save = function()
      if not vim.g.autoformat then return nil end
      return {}
    end,
  }
  local set = vim.keymap.set
  local function toggle_format() vim.g.autoformat = not vim.g.autoformat end
  set('n', [[\f]], toggle_format, { desc = "Toggle 'vim.g.autoformat'" })
end)
