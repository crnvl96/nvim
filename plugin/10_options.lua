-- General ====================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:1,hor:2'
vim.o.switchbuf = 'usetab'
vim.o.undofile = true
vim.o.clipboard = 'unnamedplus'

vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.o.swapfile = false

vim.cmd 'filetype plugin indent on'
if vim.fn.exists 'syntax_on' ~= 1 then vim.cmd 'syntax enable' end

-- UI =========================================================================
vim.o.breakindent = true
vim.o.breakindentopt = 'list:-1'
vim.o.colorcolumn = '+1'
vim.o.cursorline = true
vim.o.linebreak = true
vim.o.list = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.pumheight = 10
vim.o.ruler = false
vim.o.shortmess = 'CFOSWaco'
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.winborder = 'single'
vim.o.wrap = false
vim.o.laststatus = 0

vim.o.cursorlineopt = 'screenline,number'

vim.o.fillchars = 'eob: ,fold:╌'
vim.o.listchars = 'extends:…,nbsp:␣,precedes:…,tab:  '

vim.o.foldlevel = 10
vim.o.foldmethod = 'indent'
vim.o.foldnestmax = 10
vim.o.foldtext = ''

-- Editing ====================================================================
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.formatoptions = 'rqnl1j'
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spelllang = 'en,pt'
vim.o.spelloptions = 'camel'
vim.o.tabstop = 4
vim.o.virtualedit = 'block'

vim.o.iskeyword = '@,48-57,_,192-255,-'

vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

vim.o.complete = '.,w,b,kspell'
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'

-- Autocommands ===============================================================

local f = function() vim.cmd 'setlocal formatoptions-=c formatoptions-=o' end
_G.Config.new_autocmd('FileType', nil, f, "Proper 'formatoptions'")

-- Diagnostics ================================================================

local diagnostic_opts = {
  signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
  underline = { severity = { min = 'HINT', max = 'ERROR' } },
  virtual_lines = false,
  virtual_text = {
    current_line = true,
    severity = { min = 'ERROR', max = 'ERROR' },
  },
  update_in_insert = false,
}

MiniDeps.later(function() vim.diagnostic.config(diagnostic_opts) end)
