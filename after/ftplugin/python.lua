vim.cmd('setlocal colorcolumn=89')

Utils.Set('n', '<Leader>dpc', function() require('dap-python').test_class() end, { desc = 'Debug class' })
Utils.Set('n', '<Leader>dpt', function() require('dap-python').test_method() end, { desc = 'Debug method' })
