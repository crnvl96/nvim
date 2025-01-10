vim.cmd('setlocal colorcolumn=89')

local set = vim.keymap.set

set('n', '<Leader>dpc', '<Cmd>lua require("dap-python").test_class()<CR>', { desc = 'Debug class' })
set('n', '<Leader>dpt', '<Cmd>lua require("dap-python").test_method()<CR>', { desc = 'Debug method' })
