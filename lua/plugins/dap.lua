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
            local icons = {
                Stopped = { ' ', 'DiagnosticWarn', 'DapStoppedLine' },
                Breakpoint = { ' ', 'DiagnosticInfo', nil, nil },
                BreakpointCondition = { ' ', 'DiagnosticInfo', nil, nil },
                BreakpointRejected = { ' ', 'DiagnosticError', nil, nil },
                LogPoint = { ' ', 'DiagnosticInfo', nil, nil },
            }
            local javascript_filetypes = {
                'typescript',
                'javascript',
                'typescriptreact',
                'javascriptreact',
                'javascript.jsx',
                'typescript.tsx',
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

            for _, adapter in ipairs({ 'node', 'pwa-node' }) do
                vscode.type_to_filetypes[adapter] = javascript_filetypes
            end

            for _, filetype in ipairs(javascript_filetypes) do
                if not dap.configurations[filetype] then
                    dap.configurations[filetype] = {
                        {
                            type = 'pwa-node',
                            request = 'launch',
                            name = 'Launch file (custom)',
                            program = '${file}',
                            cwd = '${workspaceFolder}',
                        },
                        {
                            type = 'pwa-node',
                            request = 'attach',
                            name = 'Attach (custom)',
                            processId = require('dap.utils').pick_process,
                            cwd = vim.fn.getcwd(),
                            sourceMaps = true,
                            resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
                            skipFiles = { '${workspaceFolder}/node_modules/**/*.js' },
                        },
                    }
                end
            end

            if not dap.adapters['pwa-node'] then
                dap.adapters['pwa-node'] = {
                    type = 'server',
                    host = 'localhost',
                    port = '${port}',
                    executable = {
                        command = 'node',
                        args = {
                            vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
                            '${port}',
                        },
                    },
                }
            end

            if not dap.adapters['node'] then
                dap.adapters['node'] = function(cb, config)
                    if config.type == 'node' then config.type = 'pwa-node' end
                    local nativeAdapter = dap.adapters['pwa-node']
                    if type(nativeAdapter) == 'function' then
                        nativeAdapter(cb, config)
                    else
                        cb(nativeAdapter)
                    end
                end
            end
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
