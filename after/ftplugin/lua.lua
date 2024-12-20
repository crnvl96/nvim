-- stylua: ignore start
vim.keymap.set( 'n', '<Leader>lo', '<Cmd>luafile %<CR><Cmd>echo "Sourced lua"<CR>', { desc = 'lua: source current buffer' })
vim.keymap.set( 'n', '<Leader>lu', '<Cmd>lua MiniDoc.generate()<CR>', { desc = 'minidoc: generate documentation for file(s)' })
