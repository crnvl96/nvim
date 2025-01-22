vim.cmd('setlocal colorcolumn=89')

Snacks.indent.enable()

Utils.Keymap('Debug python class', {
  desc = 'Debug python class',
  lhs = '<Leader>dpc',
  rhs = function()
    local py = require('dap-python')
    py.test_class()
  end,
  buffer = true,
})

Utils.Keymap('Debug python method', {
  desc = 'Debug python method',
  lhs = '<Leader>dpm',
  rhs = function()
    local py = require('dap-python')
    py.test_method()
  end,
  buffer = true,
})

vim.b.miniclue_config = {
  clues = {
    { mode = 'n', keys = '<Leader>dp', desc = '+Python' },
  },
}
