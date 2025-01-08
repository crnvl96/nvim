vim.cmd('setlocal colorcolumn=89')

vim.keymap.set('n', '<Leader>dpc', '<Cmd>lua require("dap-python").test_class()<CR>', { desc = 'Debug class' })
vim.keymap.set('n', '<Leader>dpt', '<Cmd>lua require("dap-python").test_method()<CR>', { desc = 'Debug method' })
