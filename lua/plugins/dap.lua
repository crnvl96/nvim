return {
    { 'rcarriga/nvim-dap-ui' },
    { 'nvim-neotest/nvim-nio' },
    { 'nvim-lua/plenary.nvim' },
    {
        'mfussenegger/nvim-dap-python',
        config = function() require('dap-python').setup('python') end,
    },
    {
        'mfussenegger/nvim-dap',
        opts = function()
            return {
                setup_signs = function()
                    for name, sign in pairs({
                        Stopped = { '', 'DiagnosticWarn', 'DapStoppedLine' },
                        Breakpoint = '',
                        BreakpointCondition = '',
                        BreakpointRejected = { '', 'DiagnosticError' },
                        LogPoint = '',
                    }) do
                        sign = type(sign) == 'table' and sign or { sign }
                        vim.fn.sign_define('Dap' .. name, {
                            text = sign[1] --[[@as string]]
                                .. ' ',
                            texthl = sign[2] or 'DiagnosticInfo',
                            linehl = sign[3],
                            numhl = sign[3],
                        })
                    end
                end,
                sync_vscode = function()
                    require('dap.ext.vscode').json_decode = function(str)
                        return vim.json.decode(require('plenary.json').json_strip_comments(str))
                    end

                    if vim.fn.filereadable('.vscode/launch.json') then require('dap.ext.vscode').load_launchjs() end
                end,
                typescript_setup = function()
                    local filetypes = {
                        'typescript',
                        'javascript',
                        'typescriptreact',
                        'javascriptreact',
                        'javascript.jsx',
                        'typescript.tsx',
                    }

                    for _, adapter in ipairs({ 'node', 'pwa-node' }) do
                        require('dap.ext.vscode').type_to_filetypes[adapter] = filetypes
                    end

                    for _, filetype in ipairs(filetypes) do
                        if not require('dap').configurations[filetype] then
                            require('dap').configurations[filetype] = {
                                {
                                    name = '----------------',
                                },
                                {
                                    type = 'pwa-node',
                                    request = 'launch',
                                    name = 'Launch file',
                                    program = '${file}',
                                    cwd = '${workspaceFolder}',
                                },
                                {
                                    type = 'pwa-node',
                                    request = 'attach',
                                    name = 'Attach',
                                    processId = require('dap.utils').pick_process,
                                    cwd = vim.fn.getcwd(),
                                    sourceMaps = true,
                                    resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
                                    skipFiles = { '${workspaceFolder}/node_modules/**/*.js' },
                                },
                                {
                                    name = '----------------',
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
                                    vim.fn.stdpath('data')
                                        .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
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
            }
        end,
        config = function(_, opts)
            opts.setup_signs()

            require('dapui').setup()
            require('dap').listeners.before.attach.dapui_config = require('dapui').open
            require('dap').listeners.before.launch.dapui_config = require('dapui').open

            opts.sync_vscode()
            opts.typescript_setup()
        end,
        keys = function()
            return {
                { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'breakpoint' },
                { '<leader>dc', function() require('dap').continue() end, desc = 'continue' },
                { '<leader>dl', function() require('dap').run_last() end, desc = 'run last' },
                { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'repl' },
                { '<leader>ds', function() require('dap').session() end, desc = 'session' },
                { '<leader>dt', function() require('dap').terminate() end, desc = 'terminate' },
                { '<leader>dw', function() require('dap.ui.widgets').hover() end, desc = 'hover' },
                { '<leader>du', function() require('dapui').toggle() end, desc = 'ui' },
            }
        end,
    },
}
