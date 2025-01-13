-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true })

vim.keymap.set('i', ',', ',<C-g>u')
vim.keymap.set('i', '.', '.<C-g>u')
vim.keymap.set('i', ';', ';<C-g>u')

vim.keymap.set('x', 'p', 'P')

vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<C-w>+', '<Cmd>resize +5<CR>', { remap = true })
vim.keymap.set('n', '<C-w>-', '<Cmd>resize -5<CR>', { remap = true })
vim.keymap.set('n', '<C-w><', '<Cmd>vertical resize -20<CR>', { remap = true })
vim.keymap.set('n', '<C-w>>', '<Cmd>vertical resize +20<CR>', { remap = true })

vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>', { remap = true })
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>', { remap = true })
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>', { remap = true })
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>', { remap = true })

vim.keymap.set({ 'n', 'v', 'i' }, '<Esc>', '<Esc><Cmd>nohl<CR><Esc>')
vim.keymap.set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>w<CR><Esc>')

vim.keymap.set('x', '>', '>gv')
vim.keymap.set('x', '<', '<gv')

vim.keymap.set('n', '<Leader>ba', '<Cmd>b#<CR>', { desc = 'Alternate buffer' })
vim.keymap.set('n', '<Leader>bd', '<Cmd>bd<CR>', { desc = 'Delete current buffer' })

vim.keymap.set('n', '<Leader>tc', '<Cmd>tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<Leader>to', '<Cmd>tabonly<CR>', { desc = 'Close other tabs' })
