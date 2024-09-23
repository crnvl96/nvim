return {
    { 'rcarriga/nvim-dap-ui' },
    { 'nvim-neotest/nvim-nio' },
    { 'nvim-lua/plenary.nvim' },
    { 'mfussenegger/nvim-dap-python' },
    {
        'mfussenegger/nvim-dap',
        config = function()
            local dap = require('dap')
            local dapui = require('dapui')
            local dappy = require('dap-python')
            local json = require('plenary.json')
            local vscode = require('dap.ext.vscode')
            local has_launch = vim.fn.filereadable('.vscode/launch.json')
            local debugpy_path = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python'
            local dapjs = require('config.debug').dapjs
            local icons = {
                Stopped = { ' ', 'DiagnosticWarn', 'DapStoppedLine' },
                Breakpoint = { ' ', 'DiagnosticInfo', nil, nil },
                BreakpointCondition = { ' ', 'DiagnosticInfo', nil, nil },
                BreakpointRejected = { ' ', 'DiagnosticError', nil, nil },
                LogPoint = { ' ', 'DiagnosticInfo', nil, nil },
            }

            for name, sign in pairs(icons) do
                vim.fn.sign_define(
                    'Dap' .. name,
                    { text = sign[1], texthl = sign[2], linehl = sign[3], numhl = sign[3] }
                )
            end

            dapui.setup()
            dap.listeners.before.attach.dapui_config = dap.open
            dap.listeners.before.launch.dapui_config = dapui.open

            vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
            if has_launch then vscode.load_launchjs() end

            dappy.setup(debugpy_path)
            dapjs.setup()
        end,
        keys = {
            { '<Leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Breakpoint' },
            { '<Leader>dc', function() require('dap').continue() end, desc = 'Continue' },
            { '<Leader>dl', function() require('dap').run_last() end, desc = 'Run last' },
            { '<Leader>dr', function() require('dap').repl.toggle() end, desc = 'Repl' },
            { '<Leader>ds', function() require('dap').session() end, desc = 'Session' },
            { '<Leader>dt', function() require('dap').terminate() end, desc = 'Terminate' },
            { '<Leader>dw', function() require('dap.ui.widgets').hover() end, desc = 'Hover' },
            { '<Leader>du', function() require('dapui').toggle() end, desc = 'UI' },
            { '<leader>dPt', function() require('dap-python').test_method() end, desc = 'Debug Method', ft = 'python' },
            { '<leader>dPc', function() require('dap-python').test_class() end, desc = 'Debug Class', ft = 'python' },
        },
    },
}
