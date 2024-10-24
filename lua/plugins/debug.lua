return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'mfussenegger/nvim-dap-python',
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    require('nvim-dap-virtual-text').setup()

    local dap = require('dap')
    local dapui = require('dapui')

    dapui.setup()

    dap.listeners.after.event_initialized.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close

    require('overseer').enable_dap()

    local package_path = require('mason-registry').get_package('debugpy'):get_install_path()
    require('dap-python').setup(package_path .. '/venv/bin/python')

    require('dap.ext.vscode').json_decode = function(str)
      return vim.json.decode(require('plenary.json').json_strip_comments(str))
    end
  end,
	-- stylua: ignore
  keys = {
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
    { '<leader>dc', function() require('dap').continue() end, desc = 'Continue Execution' },
    { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'Run to cursor' },
    { '<leader>dt', function() require('dap').terminate() end, desc = 'Terminate session' },
    { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle UI' },
    { '<leader>de', function() require('dapui').eval(nil, { enter = true }) end, desc = 'Eval expression', mode = { 'n', 'v' } },
    { '<leader>dPt', function() require('dap-python').test_method() end, desc = 'Debug Method', ft = 'python' },
    { '<leader>dPc', function() require('dap-python').test_class() end, desc = 'Debug Class', ft = 'python' },
  },
}
