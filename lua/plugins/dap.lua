return {
  'mfussenegger/nvim-dap',
  dependencies = { 'rcarriga/nvim-dap-ui' },
  config = function()
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    for name, sign in pairs({
      Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
      Breakpoint = ' ',
      BreakpointCondition = ' ',
      BreakpointRejected = { ' ', 'DiagnosticError' },
      LogPoint = '.>',
    }) do
      sign = type(sign) == 'table' and sign or { sign }
      vim.fn.sign_define(
        'Dap' .. name,
        { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] }
      )
    end

    local dap = require('dap')
    local dapui = require('dapui')
    local overseer = require('overseer')

    dapui.setup()
    overseer.enable_dap()

    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close({}) end
    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close({}) end

    local vscode = require('dap.ext.vscode')
    local json = require('plenary.json')
    vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
  end,
  keys = {
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
    { '<leader>dc', function() require('dap').continue() end, desc = 'Continue Execution' },
    { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'Run to cursor' },
    { '<leader>dt', function() require('dap').terminate() end, desc = 'Terminate session' },
    { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle UI' },
    {
      '<leader>de',
      function() require('dapui').eval(nil, { enter = true }) end,
      desc = 'Eval expression',
      mode = { 'n', 'v' },
    },
  },
}
