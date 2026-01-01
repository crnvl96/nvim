vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24.11.0/bin'
vim.g.node_host_prog = node_bin .. '/node'
vim.env.PATH = node_bin .. ':' .. vim.env.PATH

vim.cmd.colorscheme 'miniwinter'

MiniDeps.later(function()
  local conf = vim.diagnostic.config
  conf {
    signs = { priority = 9999, severity = { min = 'HINT', max = 'ERROR' } },
    underline = { severity = { min = 'HINT', max = 'ERROR' } },
    virtual_text = { current_line = true, severity = { min = 'ERROR', max = 'ERROR' } },
    virtual_lines = false,
    update_in_insert = false,
  }
end)

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
