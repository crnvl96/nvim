MiniDeps.add({
    source = 'mfussenegger/nvim-dap',
    depends = {
        { source = 'nvim-lua/plenary.nvim' },
        { source = 'nvim-neotest/nvim-nio' },
        { source = 'rcarriga/nvim-dap-ui' },
        { source = 'nvim-treesitter/nvim-treesitter' },
    },
})

vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

local dap = require('dap')
local dapui = require('dapui')
local vscode = require('dap.ext.vscode')
local json = require('plenary.json')

dapui.setup({
    floating = { border = 'none' },
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

dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close({}) end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close({}) end
dap.defaults.fallback.force_external_terminal = true
dap.defaults.fallback.external_terminal = { command = vim.env.HOME .. '/.local/bin/kitty', args = { '-e' } } -- dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end

if vim.fn.filereadable('.vscode/launch.json') then vscode.load_launchjs() end

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

local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

vscode.type_to_filetypes['node'] = js_filetypes
vscode.type_to_filetypes['pwa-node'] = js_filetypes

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
                cwd = '${workspaceFolder}',
            },
            {
                type = 'pwa-node',
                request = 'launch',
                name = 'Debug NPM script',
                runtimeExecutable = 'npm',
                runtimeArgs = function()
                    local script_name
                    vim.ui.input(
                        { prompt = 'Enter the NPM script to debug: ' },
                        function(input) script_name = input end
                    )
                    return { 'run', script_name }
                end,
                cwd = '${workspaceFolder}',
                console = 'integratedTerminal',
            },
        }
    end
end

local eval = function() require('dapui').eval(nil, { enter = true }) end

vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = 'Continue' })
vim.keymap.set('n', '<leader>dC', function() require('dap').run_to_cursor() end, { desc = 'Run to Cursor' })
vim.keymap.set('n', '<leader>dg', function() require('dap').goto_() end, { desc = 'Go to Line (No Execute)' })
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc = 'Step Into' })
vim.keymap.set('n', '<leader>dj', function() require('dap').down() end, { desc = 'Down' })
vim.keymap.set('n', '<leader>dk', function() require('dap').up() end, { desc = 'Up' })
vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end, { desc = 'Run Last' })
vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end, { desc = 'Step Out' })
vim.keymap.set('n', '<leader>dO', function() require('dap').step_over() end, { desc = 'Step Over' })
vim.keymap.set('n', '<leader>dp', function() require('dap').pause() end, { desc = 'Pause' })
vim.keymap.set('n', '<leader>dr', function() require('dap').repl.toggle() end, { desc = 'Toggle REPL' })
vim.keymap.set('n', '<leader>ds', function() require('dap').session() end, { desc = 'Session' })
vim.keymap.set('n', '<leader>dt', function() require('dap').terminate() end, { desc = 'Terminate' })
vim.keymap.set('n', '<leader>du', function() require('dapui').toggle({}) end, { desc = 'Dap UI' })
vim.keymap.set('n', '<leader>dw', function() require('dap.ui.widgets').hover() end, { desc = 'Widgets' })
vim.keymap.set({ 'n', 'v' }, '<leader>de', eval, { desc = 'Eval' })
