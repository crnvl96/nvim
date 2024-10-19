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

vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
if vim.fn.filereadable('.vscode/launch.json') then vscode.load_launchjs() end

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
dap.defaults.fallback.external_terminal = { command = vim.env.HOME .. '/.local/bin/kitty', args = { '-e' } }

Lang.get_debug_adapters(dap, vscode)

local function set(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, opts) end

set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = 'Dap toggle breakpoint' })
set('n', '<leader>dc', function() dap.continue() end, { desc = 'Dap continue' })
set('n', '<leader>dC', function() dap.run_to_cursor() end, { desc = 'Dap run to cursor' })
set('n', '<leader>dl', function() dap.run_last() end, { desc = 'Dap run Last' })
set('n', '<leader>dr', function() dap.repl.toggle() end, { desc = 'Dap toggle REPL' })
set('n', '<leader>ds', function() dap.session() end, { desc = 'Dap session' })
set('n', '<leader>dt', function() dap.terminate() end, { desc = 'Dap terminate' })
set('n', '<leader>du', function() dapui.toggle() end, { desc = 'Dap UI' })
set({ 'n', 'v' }, '<leader>de', function() dapui.eval(nil, { enter = true }) end, { desc = 'Dap eval' })
