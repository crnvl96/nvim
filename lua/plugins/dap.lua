MiniDeps.add({ source = 'theHamsta/nvim-dap-virtual-text' })
MiniDeps.add({ source = 'mfussenegger/nvim-dap' })
MiniDeps.add({ source = 'jay-babu/mason-nvim-dap.nvim' })

vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

local dapvt = require('nvim-dap-virtual-text')
dapvt.setup({ virt_text_pos = 'eol' })

MiniDeps.add({ source = 'rcarriga/nvim-dap-ui' })

local dapui = require('dapui')
dapui.setup()

local mason_dap = require('mason-nvim-dap')
mason_dap.setup()

local dap = require('dap')
local fzf = require('fzf-lua')
local function handle_conditional_bp() dap.set_breakpoint(vim.fn.input('Condition: ')) end

vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'toggle dapui' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'start/continue' })
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'toggle breakpoint' })
vim.keymap.set('n', '<leader>dB', handle_conditional_bp, { desc = 'conditional breakpoint' })
vim.keymap.set('n', '<leader>dd', fzf.dap_commands, { desc = 'commands' })
vim.keymap.set('n', '<leader>do', fzf.dap_configurations, { desc = 'configs' })
vim.keymap.set('n', '<leader>dl', fzf.dap_breakpoints, { desc = 'breakpoints' })
vim.keymap.set('n', '<leader>di', fzf.dap_variables, { desc = 'variables' })
vim.keymap.set('n', '<leader>df', fzf.dap_frames, { desc = 'frames' })
vim.keymap.set('n', '<leader>de', function() require('dapui').eval({}, { enter = true }) end, { desc = 'eval' })

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

local vscode = require('dap.ext.vscode')
local json = require('plenary.json')
vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
if vim.fn.filereadable('.vscode/launch.json') then vscode.load_launchjs() end

MiniDeps.add({ source = 'leoluz/nvim-dap-go' })

-- go
local dap_go = require('dap-go')
dap_go.setup({ delve = { detached = vim.fn.has('win32') == 0 } })

-- js/ts
local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

vscode.type_to_filetypes['node'] = js_filetypes
vscode.type_to_filetypes['pwa-node'] = js_filetypes

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
                name = 'Attach to running process',
                processId = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
                sourceMaps = true,
                protocol = 'inspector',
                skipFiles = {
                    '<node_internals>/**',
                    'node_modules/**',
                },
                resolveSourceMapLocations = {
                    '${workspaceFolder}/**',
                    '!**/node_modules/**',
                },
            },
            { name = '-----------------' },
        }
    end
end
