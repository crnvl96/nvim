local path = vim.env.HOME .. '/.local/share/mise/installs/node/24.9.0/bin/'
vim.env.PATH = path .. ':' .. vim.env.PATH

vim.g.node_host_prog = path .. 'node'
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.cmd 'filetype plugin indent on'
vim.cmd 'packadd cfilter'
vim.cmd 'packadd matchit'

if vim.fn.exists 'syntax_on' ~= 1 then vim.cmd 'syntax enable' end
