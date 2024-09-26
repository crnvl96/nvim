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

        require('dap.ext.vscode').json_decode = function(str)
            return vim.json.decode(require('plenary.json').json_strip_comments(str))
        end

        if vim.fn.filereadable('.vscode/launch.json') then require('dap.ext.vscode').load_launchjs() end

        require('dap-python').setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')

        local javascript_filetypes = {
            'typescript',
            'javascript',
            'typescriptreact',
            'javascriptreact',
            'javascript.jsx',
            'typescript.tsx',
        }

        for _, adapter in ipairs({ 'node', 'pwa-node' }) do
            require('dap.ext.vscode').type_to_filetypes[adapter] = javascript_filetypes
        end

        for _, filetype in ipairs(javascript_filetypes) do
            if not require('dap').configurations[filetype] then
                require('dap').configurations[filetype] = {
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

        if not require('dap').adapters['pwa-node'] then
            require('dap').adapters['pwa-node'] = {
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

        if not require('dap').adapters['node'] then
            require('dap').adapters['node'] = function(cb, config)
                if config.type == 'node' then config.type = 'pwa-node' end
                local nativeAdapter = require('dap').adapters['pwa-node']
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
        { '<Leader>dt', function() require('dap').terminate() end, desc = 'Terminate' },
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
}
