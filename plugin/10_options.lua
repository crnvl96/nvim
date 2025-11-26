local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24.11.0/bin'
vim.g.node_host_prog = node_bin .. '/node'
vim.env.PATH = node_bin .. ':' .. vim.env.PATH

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

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-after-yank', {}),
  callback = function() vim.highlight.on_yank() end,
})

vim.cmd 'filetype plugin indent on'
if vim.fn.exists 'syntax_on' ~= 1 then vim.cmd 'syntax enable' end
