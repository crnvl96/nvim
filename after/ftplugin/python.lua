vim.cmd('setlocal colorcolumn=89')

-- stylua: ignore start
vim.keymap.set('n', '<Leader>dpc', '<Cmd>lua require("dap-python").test_class()<CR>', { desc = 'dap-py: debug class under cursor' })
vim.keymap.set('n', '<Leader>dpt', '<Cmd>lua require("dap-python").test_method()<CR>', { desc = 'dap-py: debug method under cursor' })
