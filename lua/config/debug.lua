local M = {
    dapjs = {
        setup = function()
            local javascript_filetypes = {
                'typescript',
                'javascript',
                'typescriptreact',
                'javascriptreact',
                'javascript.jsx',
                'typescript.tsx',
            }

            local javascript_adapters = {
                'node',
                'pwa-node',
            }

            local dap = require('dap')
            local vscode = require('dap.ext.vscode')

            for _, adapter in ipairs(javascript_adapters) do
                vscode.type_to_filetypes[adapter] = javascript_filetypes
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
    },
}

return M
