vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.whoami = 'crnvl96'
vim.g.bigfile_size = 1024 * 250

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.scrolloff = 8
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.number = true
vim.o.timeoutlen = 200
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'

vim.o.mouse = 'a'

vim.o.guicursor = ''
vim.o.virtualedit = 'block'
vim.o.splitkeep = 'screen'

vim.o.swapfile = false
vim.o.undofile = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.wrap = false
vim.o.linebreak = true

if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end
vim.cmd('packadd cfilter')
