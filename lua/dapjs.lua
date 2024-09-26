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
    if not require('dap').configurations[filetype] then
        require('dap').configurations[filetype] = {
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
