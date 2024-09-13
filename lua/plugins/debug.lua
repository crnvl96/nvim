vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

require('dapui').setup()
require('nvim-dap-virtual-text').setup()

require('dap').listeners.before.attach.dapui_config = require('dapui').open
require('dap').listeners.before.launch.dapui_config = require('dapui').open
require('dap').listeners.before.event_terminated.dapui_config = require('dapui').close
require('dap').listeners.before.event_exited.dapui_config = require('dapui').close

require('dap.ext.vscode').json_decode = function(str)
    return vim.json.decode(require('plenary.json').json_strip_comments(str))
end

if vim.fn.filereadable('.vscode/launch.json') then require('dap.ext.vscode').load_launchjs() end

local function setup_javascript_debugger()
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
end

local function setup_go_debugger()
    require('dap-go').setup({
        dap_configurations = {
            {
                name = '-------------',
            },
            {
                type = 'go',
                name = 'Attach remote',
                mode = 'remote',
                request = 'attach',
            },
            {
                name = '-------------',
            },
        },
        delve = {
            detached = vim.fn.has('win32') == 0,
        },
        tests = {
            verbose = true,
        },
    })
end

setup_javascript_debugger()
setup_go_debugger()
