vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.undofile = true
vim.o.writebackup = false
vim.o.showcmd = false
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.wrap = false
vim.o.number = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.signcolumn = 'yes'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.infercase = true
vim.o.smartindent = true
vim.o.virtualedit = 'block'
vim.o.splitkeep = 'screen'
vim.o.showmode = false
vim.o.ruler = false
vim.o.cmdheight = 1
vim.o.termguicolors = true
vim.o.clipboard = 'unnamedplus'
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.laststatus = 0
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.foldlevel = 99
vim.o.swapfile = false
vim.o.autoread = true
vim.o.wildignorecase = true
vim.o.mousescroll = 'ver:2,hor:6'
vim.o.switchbuf = 'usetab'
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.o.colorcolumn = '+1'
vim.o.cursorline = true
vim.o.list = true
vim.o.cursorlineopt = 'screenline,number'
vim.o.breakindentopt = 'list:-1'
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.formatoptions = 'rqnl1j'
vim.o.conceallevel = 0

vim.opt.wildoptions:append('fuzzy')
vim.opt.completeopt:append('fuzzy')

vim.cmd.packadd('cfilter')
vim.cmd('filetype plugin indent on')

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
