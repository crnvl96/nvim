return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'rcarriga/nvim-dap-ui',
                opts = {
                    floating = {
                        border = 'rounded',
                    },
                },
                config = function(_, opts)
                    local dap = require('dap')
                    local dapui = require('dapui')
                    dapui.setup(opts)
                    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
                    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close({}) end
                    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close({}) end
                end,
                keys = {
                    { '<leader>du', function() require('dapui').toggle({}) end, desc = 'Dap UI' },
                    { '<leader>de', function() require('dapui').eval() end, desc = 'Eval', mode = { 'n', 'v' } },
                },
            },
            {
                'mfussenegger/nvim-dap-python',
                opts = {
                    path = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python',
                },
                config = function(_, opts) require('dap-python').setup(opts.path) end,
            },
            {
                'jbyuki/one-small-step-for-vimkind',
                config = function()
                    local dap = require('dap')
                    dap.adapters.nlua = function(callback, conf)
                        local adapter = {
                            type = 'server',
                            host = conf.host or '127.0.0.1',
                            port = conf.port or 8086,
                        }

                        if conf.start_neovim then
                            local dap_run = dap.run
                            dap.run = function(c)
                                adapter.port = c.port
                                adapter.host = c.host
                            end
                            require('osv').run_this()
                            dap.run = dap_run
                        end

                        callback(adapter)
                    end

                    dap.configurations.lua = {
                        {
                            type = 'nlua',
                            request = 'attach',
                            name = 'Run this file',
                            start_neovim = {},
                        },
                        {
                            type = 'nlua',
                            request = 'attach',
                            name = 'Attach to running Neovim instance (port = 8086)',
                            port = 8086,
                        },
                    }
                end,
                keys = {
                    {
                        '<leader>dl',
                        function() require('osv').launch({ port = 8086 }) end,
                        desc = 'Launch nlua (8086)',
                        ft = 'lua',
                    },
                },
            },
        },
        init = function()
            for name, sign in pairs({
                Stopped = { ' ', 'DiagnosticWarn', 'DapStoppedLine' },
                Breakpoint = { ' ', 'DiagnosticInfo', nil, nil },
                BreakpointCondition = { ' ', 'DiagnosticInfo', nil, nil },
                BreakpointRejected = { ' ', 'DiagnosticError', nil, nil },
                LogPoint = { ' ', 'DiagnosticInfo', nil, nil },
            }) do
                vim.fn.sign_define(
                    'Dap' .. name,
                    { text = sign[1], texthl = sign[2], linehl = sign[3], numhl = sign[3] }
                )
            end
        end,
        config = function()
            local dap = require('dap')

            -- setup dap config by VsCode launch.json file
            local vscode = require('dap.ext.vscode')
            local json = require('plenary.json')
            vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end

            -- Extends dap.configurations with entries read from .vscode/launch.json
            if vim.fn.filereadable('.vscode/launch.json') then vscode.load_launchjs() end

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
            { '<Leader>dt', function() require('dap').terminate() end, desc = 'Terminate' },
        },
    },
}
