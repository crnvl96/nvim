MiniDeps.later(function()
  MiniDeps.add 'mfussenegger/nvim-dap'
  MiniDeps.add 'suketa/nvim-dap-ruby'

  require('dap-ruby').setup()

  local widgets = require 'dap.ui.widgets'

  vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint)
  vim.keymap.set('n', '<leader>dc', require('dap').continue)
  vim.keymap.set('n', '<leader>dt', require('dap').terminate)
  vim.keymap.set('n', '<Leader>dr', require('dap').repl.toggle)
  vim.keymap.set({ 'n', 'v' }, '<Leader>dh', require('dap.ui.widgets').hover)
  vim.keymap.set(
    'n',
    '<Leader>df',
    function() widgets.sidebar(widgets.frames).open() end
  )
  vim.keymap.set(
    'n',
    '<Leader>ds',
    function() widgets.sidebar(widgets.scopes).open() end
  )
end)
