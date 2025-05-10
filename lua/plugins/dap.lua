MiniDeps.later(function()
  MiniDeps.add 'mfussenegger/nvim-dap'
  MiniDeps.add 'mfussenegger/nvim-dap-python'

  local widgets = require 'dap.ui.widgets'
  local frames = function() widgets.sidebar(widgets.frames).open() end
  local scopes = function() widgets.sidebar(widgets.scopes).open() end

  require('dap-python').setup 'uv'
  require('dap-python').test_runner = 'pytest'

  vim.keymap.set('n', '<leader>dpm', require('dap-python').test_method)
  vim.keymap.set('n', '<leader>dpc', require('dap-python').test_class)
  vim.keymap.set('n', '<leader>dps', require('dap-python').debug_selection)

  vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint)
  vim.keymap.set('n', '<leader>dc', require('dap').continue)
  vim.keymap.set('n', '<leader>dt', require('dap').terminate)
  vim.keymap.set('n', '<Leader>dr', require('dap').repl.toggle)
  vim.keymap.set({ 'n', 'v' }, '<Leader>dh', require('dap.ui.widgets').hover)
  vim.keymap.set('n', '<Leader>df', frames)
  vim.keymap.set('n', '<Leader>ds', scopes)
end)
