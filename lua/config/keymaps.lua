vim.keymap.set({ 'n', 'x', 'i' }, '<C-s>', '<Esc><Cmd>w<CR><Esc>', { desc = 'Save buffer' })
vim.keymap.set({ 'n', 'x', 'i' }, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { desc = 'Better Esc' })

vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, desc = 'Move down by visual line' })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, desc = 'Move up by visual line' })

vim.keymap.set({ 'n', 'x' }, '<c-d>', '<c-d>zz', { desc = 'Move window down and center' })
vim.keymap.set({ 'n', 'x' }, '<c-u>', '<c-u>zz', { desc = 'Move window up and center' })

vim.keymap.set('x', 'p', 'P', { desc = 'Better paste (do not populate the yank register)' })

vim.keymap.set('n', '<c-up>', '<Cmd>resize +5<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<c-down>', '<Cmd>resize -5<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<c-left>', '<Cmd>vertical resize -20<CR>', { desc = 'Increase window width' })
vim.keymap.set('n', '<c-right>', '<Cmd>vertical resize +20<CR>', { desc = 'Decrease window width' })

vim.keymap.set('n', '<c-h>', '<c-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<c-j>', '<c-w>j', { desc = 'Go to down window' })
vim.keymap.set('n', '<c-k>', '<c-w>k', { desc = 'Go to down window' })
vim.keymap.set('n', '<c-l>', '<c-w>l', { desc = 'Go to right window' })

vim.keymap.set('x', '<', '<gv', { desc = 'Indent visually selected lines' })
vim.keymap.set('x', '>', '>gv', { desc = 'Dedent visually selected lines' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
