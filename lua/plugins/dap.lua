return {
    'mfussenegger/nvim-dap',
    dependencies = {
        { 'nvim-neotest/nvim-nio' },
        { 'nvim-lua/plenary.nvim' },
        { 'ibhagwan/fzf-lua' },
        {
            'mfussenegger/nvim-dap-python',
            config = function()
                local debugpy_path = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python'
                local dappy = require('dap-python')
                dappy.setup(debugpy_path)
            end,
            keys = {
                {
                    '<leader>dPt',
                    function() require('dap-python').test_method() end,
                    desc = 'Debug Method',
                    ft = 'python',
                },
                {
                    '<leader>dPc',
                    function() require('dap-python').test_class() end,
                    desc = 'Debug Class',
                    ft = 'python',
                },
            },
        },
        {
            'rcarriga/nvim-dap-ui',
            dependencies = {
                { 'mfussenegger/nvim-dap' },
            },
            config = function()
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
                                { id = 'stacks', size = 0.30 },
                                { id = 'breakpoints', size = 0.20 },
                                { id = 'scopes', size = 0.50 },
                            },
                            position = 'left',
                            size = 40,
                        },
                    },
                })

                require('dap').listeners.before.attach.dapui_config = require('dapui').open
                require('dap').listeners.before.launch.dapui_config = require('dapui').open
            end,
            keys = {
                { '<Leader>du', function() require('dapui').toggle() end, desc = 'Interface' },
                {
                    '<Leader>de',
                    function()
                        require('dapui').eval()
                        require('dapui').eval()
                    end,
                    desc = 'Eval',
                },
            },
        },
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

        require('dap.ext.vscode').json_decode = function(str)
            return vim.json.decode(require('plenary.json').json_strip_comments(str))
        end

        if vim.fn.filereadable('.vscode/launch.json') then require('dap.ext.vscode').load_launchjs() end

        local function debugjs_setup()
            local javascript_filetypes = {
                'typescript',
                'javascript',
                'typescriptreact',
                'javascriptreact',
                'javascript.jsx',
                'typescript.tsx',
            }

            local javascript_adapters = {
                'node',
                'pwa-node',
            }

            local dap = require('dap')
            local vscode = require('dap.ext.vscode')

            for _, adapter in ipairs(javascript_adapters) do
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
        end

        debugjs_setup()
    end,
    keys = {
        { '<Leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Breakpoint' },
        { '<Leader>dc', function() require('dap').continue() end, desc = 'Continue' },
        { '<Leader>dw', function() require('dap.ui.widgets').hover() end, desc = 'Hover' },
        { '<Leader>dl', '<cmd>FzfLua dap_breakpoints<CR>', desc = 'List Breakpoints' },
        { '<Leader>dc', '<cmd>FzfLua dap_commands<CR>', desc = 'Commands' },
        { '<Leader>df', '<cmd>FzfLua dap_frames<CR>', desc = 'Frames' },
        { '<Leader>dv', '<cmd>FzfLua dap_variables<CR>', desc = 'Variables' },
    },
}
