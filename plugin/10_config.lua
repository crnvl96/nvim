local map = function(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, opts) end
local nmap = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc }) end
local nmap_leader = function(suffix, rhs, desc) vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc }) end

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24.12.0/bin'
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

map('', '<M-e>', ':')
map('v', 'p', 'P')

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

nmap('<C-d>', '<C-d>zz', 'Scroll down and center')
nmap('<C-u>', '<C-u>zz', 'Scroll up and center')
nmap('n', 'nzz', '')
nmap('N', 'Nzz', '')
nmap('*', '*zz', '')
nmap('#', '#zz', '')
nmap('g*', 'g*zz', '')

nmap_leader('ex', function()
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.fn.getwininfo(win_id)[1].quickfix == 1 then return vim.cmd 'cclose' end
  end
  vim.cmd 'copen'
end, 'Quickfix')

nmap_leader('hh', '<Cmd>noh<CR>', 'Clear Highlights')
nmap_leader('hs', '<Esc>:noh<CR>:w<CR>', 'Save buffer')

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-after-yank', {}),
  callback = function() vim.highlight.on_yank() end,
})
