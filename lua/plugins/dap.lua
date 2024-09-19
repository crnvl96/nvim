return {
    { 'rcarriga/nvim-dap-ui' },
    {
        'mfussenegger/nvim-dap',
        config = function()
            vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

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

            local dap = require('dap')
            local dapui = require('dapui')

            dapui.setup()

            dap.listeners.before.attach.dapui_config = dapui.open
            dap.listeners.before.launch.dapui_config = dapui.open

            require('dap.ext.vscode').json_decode = function(str)
                return vim.json.decode(require('plenary.json').json_strip_comments(str))
            end

            if vim.fn.filereadable('.vscode/launch.json') then require('dap.ext.vscode').load_launchjs() end

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
        keys = function()
            local function input_prompt() vim.fn.input('Cond:') end

            return {
                -- stylua: ignore
                { '<leader>dB', function() require('dap').set_breakpoint(input_prompt()) end, desc = 'Breakpoint Condition' },
                { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
                { '<leader>dc', function() require('dap').continue() end, desc = 'Continue' },
                { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'Run to Cursor' },
                { '<leader>dl', function() require('dap').run_last() end, desc = 'Run Last' },
                { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'Toggle REPL' },
                { '<leader>ds', function() require('dap').session() end, desc = 'Session' },
                { '<leader>dt', function() require('dap').terminate() end, desc = 'Terminate' },
                { '<leader>dw', function() require('dap.ui.widgets').hover() end, desc = 'Widgets' },
                { '<leader>du', function() require('dapui').toggle() end, desc = 'ToggleUI' },
            }
        end,
    },
}
