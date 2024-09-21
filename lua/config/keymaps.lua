vim.keymap.set({ 'n', 'x', 'i' }, '<c-s>', '<esc><cmd>w<cr><esc>')

vim.keymap.set({ 'n', 'x', 'i' }, '<esc>', '<esc><cmd>noh<cr><esc>')

vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

vim.keymap.set('x', 'p', 'P')

vim.keymap.set('n', '<c-up>', '<cmd>resize +5<cr>')
vim.keymap.set('n', '<c-down>', '<cmd>resize -5<cr>')
vim.keymap.set('n', '<c-left>', '<cmd>vertical resize -20<cr>')
vim.keymap.set('n', '<c-right>', '<cmd>vertical resize +20<cr>')

vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')

vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

vim.keymap.set('n', 'n', '*<esc><cmd>noh<cr><esc>')
vim.keymap.set('n', 'N', '#<esc><cmd>noh<cr><esc>')
