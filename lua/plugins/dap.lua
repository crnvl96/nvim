return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'mfussenegger/nvim-dap-python',
        'rcarriga/nvim-dap-ui',
    },
    config = function()
        local icons = {
            Stopped = { ' ', 'DiagnosticWarn', 'DapStoppedLine' },
            Breakpoint = { ' ', 'DiagnosticInfo', nil, nil },
            BreakpointCondition = { ' ', 'DiagnosticInfo', nil, nil },
            BreakpointRejected = { ' ', 'DiagnosticError', nil, nil },
            LogPoint = { ' ', 'DiagnosticInfo', nil, nil },
        }

        for name, sign in pairs(icons) do
            vim.fn.sign_define('Dap' .. name, { text = sign[1], texthl = sign[2], linehl = sign[3], numhl = sign[3] })
        end

        require('dapui').setup({
            icons = {
                collapsed = '',
                current_frame = '',
                expanded = '',
            },
            floating = { border = 'rounded' },
            layouts = {
                {
                    elements = {
                        { id = 'breakpoints', size = 0.30 },
                        { id = 'scopes', size = 0.70 },
                    },
                    position = 'left',
                    size = 80,
                },
            },
        })

        require('dap').listeners.before.attach.dapui_config = require('dapui').open
        require('dap').listeners.before.launch.dapui_config = require('dapui').open

        require('dap-vscode').setup()
        require('dap-python').setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')
        require('dap-js').setup()
    end,
    keys = {
        { '<Leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Breakpoint' },
        { '<Leader>dc', function() require('dap').continue() end, desc = 'Continue' },
        { '<Leader>dt', function() require('dap').terminate() end, desc = 'Terminate' },
        { '<Leader>du', function() require('dapui').toggle() end, desc = 'Interface' },
        { '<leader>de', function() require('dap.ui.widgets').hover() end, desc = 'Widgets' },
    },
}
