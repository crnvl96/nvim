vim.g.whoami = 'crnvl96'
vim.g.bigfile_size = 1024 * 250

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.scrolloff = 8
vim.o.expandtab = true
vim.o.number = true
vim.o.timeoutlen = 200
vim.o.relativenumber = true

vim.o.guicursor = ''
vim.o.splitkeep = 'screen'

vim.o.swapfile = false
vim.o.wrap = false
vim.o.linebreak = true

if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end
vim.cmd('packadd cfilter')
