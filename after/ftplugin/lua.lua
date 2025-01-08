vim.keymap.set('n', '<Leader>lo', '<Cmd>luafile %<CR><Cmd>echo "Sourced lua"<CR>', { desc = 'Source current buffer' })
vim.keymap.set('n', '<Leader>lu', '<Cmd>lua MiniDoc.generate()<CR>', { desc = 'Generate documentation' })
