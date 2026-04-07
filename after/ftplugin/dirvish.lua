vim.cmd([[nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>]])

vim.keymap.set('n', '.', ':Shdo<CR>', { desc = 'Shdo', buffer = true })
vim.keymap.set('x', '.', ":'<,'>Shdo<CR>", { desc = 'Shdo', buffer = true })
