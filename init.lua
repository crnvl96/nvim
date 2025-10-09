vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.infercase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.laststatus = 2
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.scrolloff = 8
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.sidescrolloff = 24
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smoothscroll = true
vim.opt.splitbelow = true
vim.opt.splitkeep = 'screen'
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.switchbuf = 'usetab'
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 10
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 300
vim.opt.virtualedit = 'block'
vim.opt.winborder = 'double'
vim.opt.winminwidth = 5
vim.opt.wrap = false
vim.opt.writebackup = false
vim.opt.shortmess = 'aCFoOtT'

require 'opts'
require 'keymaps'
require 'pack'
require 'editor'
require 'lsp'
require 'complete'
require 'ui'
require 'filemanager'
require 'grep'
require 'find'
