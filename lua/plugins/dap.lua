return {
    { 'theHamsta/nvim-dap-virtual-text' },
    { 'rcarriga/nvim-dap-ui' },
    {
        'mfussenegger/nvim-dap',
        config = function()
            vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

            local dap = require('dap')
            local dapui = require('dapui')

            dapui.setup()
            require('nvim-dap-virtual-text').setup()

            dap.listeners.before.attach.dapui_config = dapui.open
            dap.listeners.before.launch.dapui_config = dapui.open
            dap.listeners.before.event_terminated.dapui_config = dapui.close
            dap.listeners.before.event_exited.dapui_config = dapui.close

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
            local dap = require('dap')
            local widgets = require('dap.ui.widgets')

            local function input_prompt() vim.fn.input('Cond:') end
            local function set_conditional_breakpoint() dap.set_breakpoint(input_prompt()) end

            return {
                { '<leader>d', '', desc = 'Debug' },
                { '<leader>dB', set_conditional_breakpoint, desc = 'Breakpoint Condition' },
                { '<leader>db', dap.toggle_breakpoint, desc = 'Toggle Breakpoint' },
                { '<leader>dc', dap.continue, desc = 'Continue' },
                { '<leader>dC', dap.run_to_cursor, desc = 'Run to Cursor' },
                { '<leader>dg', dap.goto_, desc = 'Go to Line (No Execute)' },
                { '<leader>di', dap.step_into, desc = 'Step Into' },
                { '<leader>dj', dap.down, desc = 'Down' },
                { '<leader>dk', dap.up, desc = 'Up' },
                { '<leader>dl', dap.run_last, desc = 'Run Last' },
                { '<leader>do', dap.step_out, desc = 'Step Out' },
                { '<leader>dO', dap.step_over, desc = 'Step Over' },
                { '<leader>dp', dap.pause, desc = 'Pause' },
                { '<leader>dr', dap.repl.toggle, desc = 'Toggle REPL' },
                { '<leader>ds', dap.session, desc = 'Session' },
                { '<leader>dt', dap.terminate, desc = 'Terminate' },
                { '<leader>dw', widgets.hover, desc = 'Widgets' },
            }
        end,
    },
}
