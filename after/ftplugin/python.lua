vim.cmd('setlocal colorcolumn=89')

Utils.Keymap2('Debug python class', {
  desc = 'Debug python class',
  lhs = '<Leader>dpc',
  rhs = function()
    local py = require('dap-python')
    py.test_class()
  end,
})

Utils.Keymap2('Debug python method', {
  desc = 'Debug python method',
  lhs = '<Leader>dpm',
  rhs = function()
    local py = require('dap-python')
    py.test_method()
  end,
})
