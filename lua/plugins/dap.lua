require('mini.deps').add('nvim-lua/plenary.nvim')
require('mini.deps').add('mfussenegger/nvim-dap')
require('mini.deps').add('nvim-neotest/nvim-nio')
require('mini.deps').add('rcarriga/nvim-dap-ui')
require('mini.deps').add('theHamsta/nvim-dap-virtual-text')

vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

require('dapui').setup()
require('nvim-dap-virtual-text').setup()

local dap, dapui = require('dap'), require('dapui')

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

local vscode = require('dap.ext.vscode')
local json = require('plenary.json')

vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
if vim.fn.filereadable('.vscode/launch.json') then vscode.load_launchjs() end

local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

vscode.type_to_filetypes['node'] = js_filetypes
vscode.type_to_filetypes['pwa-node'] = js_filetypes

if not dap.adapters['pwa-node'] then
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

for _, language in ipairs(js_filetypes) do
    if not dap.configurations[language] then
        dap.configurations[language] = {
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

vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Cond: ')) end, { desc = 'Cond BP' })
vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = 'Continue' })
vim.keymap.set('n', '<leader>da', function() dap.continue() end, { desc = 'Run with Args' })
vim.keymap.set('n', '<leader>dC', function() dap.run_to_cursor() end, { desc = 'Run to Cursor' })
vim.keymap.set('n', '<leader>dg', function() dap.goto_() end, { desc = 'Go to Line (No Execute)' })
vim.keymap.set('n', '<leader>di', function() dap.step_into() end, { desc = 'Step Into' })
vim.keymap.set('n', '<leader>dj', function() dap.down() end, { desc = 'Down' })
vim.keymap.set('n', '<leader>dk', function() dap.up() end, { desc = 'Up' })
vim.keymap.set('n', '<leader>dl', function() dap.run_last() end, { desc = 'Run Last' })
vim.keymap.set('n', '<leader>do', function() dap.step_out() end, { desc = 'Step Out' })
vim.keymap.set('n', '<leader>dO', function() dap.step_over() end, { desc = 'Step Over' })
vim.keymap.set('n', '<leader>dp', function() dap.pause() end, { desc = 'Pause' })
vim.keymap.set('n', '<leader>dr', function() dap.repl.toggle() end, { desc = 'Toggle REPL' })
vim.keymap.set('n', '<leader>ds', function() dap.session() end, { desc = 'Session' })
vim.keymap.set('n', '<leader>dt', function() dap.terminate() end, { desc = 'Terminate' })
vim.keymap.set('n', '<leader>dw', function() require('dap.ui.widgets').hover() end, { desc = 'Widgets' })
