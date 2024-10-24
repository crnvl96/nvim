vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.undofile = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.showcmd = false
vim.o.laststatus = 3
vim.o.timeoutlen = 100
vim.o.cmdheight = 0
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.cursorline = false
vim.o.linebreak = true
vim.o.number = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.ruler = false
vim.o.showmode = false
vim.o.wrap = false
vim.o.signcolumn = 'yes'
vim.o.fillchars = 'eob: '
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.virtualedit = 'block'
vim.o.splitkeep = 'screen'
vim.o.termguicolors = true
vim.o.pumblend = 0
vim.o.winblend = 0
vim.o.clipboard = 'unnamedplus'
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.foldlevel = 99
vim.o.swapfile = false
vim.o.autoread = true
vim.o.wildignorecase = true

vim.opt.wildoptions:append('fuzzy')
vim.opt.completeopt:append('fuzzy')

vim.cmd.filetype('plugin', 'indent', 'on')
vim.cmd.packadd('cfilter')
