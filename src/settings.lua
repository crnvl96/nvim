vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.o.backup = false
vim.o.mouse = 'a'
vim.o.guicursor = ''
vim.o.switchbuf = 'usetab'
vim.o.writebackup = false
vim.o.undofile = true
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.cursorline = true
vim.o.laststatus = 2
vim.o.linebreak = true
vim.o.number = true
vim.o.autoread = true
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.showmode = false
vim.o.showtabline = 0
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.cmdheight = 1
vim.o.scrolloff = 8
vim.o.cursorlineopt = 'screenline,number'
vim.o.breakindentopt = 'list:-1'
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.formatoptions = 'rqnl1j'
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.virtualedit = 'block'
vim.o.timeoutlen = 1000
vim.o.signcolumn = 'yes'
vim.o.foldmethod = 'indent'
vim.o.foldlevel = 1
vim.o.foldnestmax = 10
vim.o.foldlevelstart = 99
vim.o.foldtext = ''
vim.o.splitkeep = 'screen'
vim.o.shortmess = 'aoOWFcSC'

vim.opt.completeopt:append('fuzzy')
vim.opt.diffopt:append('linematch:60')

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end

vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')
vim.cmd('colorscheme default')

vim.diagnostic.config({ signs = false })

vim.keymap.set('n', '-', '<cmd>Ex<CR>')
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', ';', ';<c-g>u')
vim.keymap.set('x', 'p', 'P')
vim.keymap.set({ 'n', 'x', 'i' }, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { desc = 'Better Esc' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Focus on left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Focus on below window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Focus on above window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Focus on right window' })
vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
vim.keymap.set({ 'i', 'x' }, '<C-s>', '<Esc><Cmd>silent! update | redraw<CR>', { desc = 'Save' })
vim.keymap.set('n', '<C-s>', '<Cmd>silent! update | redraw<CR>', { desc = 'Save' })
vim.keymap.set({ 'n', 'x' }, '<c-d>', '<c-d>zz', { desc = 'Move window down and center' })
vim.keymap.set({ 'n', 'x' }, '<c-u>', '<c-u>zz', { desc = 'Move window up and center' })
vim.keymap.set('n', '<c-up>', '<Cmd>resize +5<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<c-down>', '<Cmd>resize -5<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<c-left>', '<Cmd>vertical resize -20<CR>', { desc = 'Increase window width' })
vim.keymap.set('n', '<c-right>', '<Cmd>vertical resize +20<CR>', { desc = 'Decrease window width' })
vim.keymap.set('x', '<', '<gv', { desc = 'Indent visually selected lines' })
vim.keymap.set('x', '>', '>gv', { desc = 'Dedent visually selected lines' })
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to Left Window' })
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to Lower Window' })
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to Upper Window' })
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to Right Window' })
vim.keymap.set('t', '<C-w>c', '<cmd>close<cr>', { desc = 'Hide Terminal' })
vim.keymap.set('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

vim.api.nvim_create_autocmd('QuickfixCmdPost', {
    group = vim.api.nvim_create_augroup('Crnvl96AutoOpenQuickfixList', {}),
    callback = function() vim.cmd('cwindow') end,
})
