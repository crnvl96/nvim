local M = {}
local H = {}

function M.get_tools() return H.list_extend(H.tools()) end
function M.get_parsers() return H.list_extend(H.parsers()) end
function M.get_servers() return H.tbl_extend(H.servers()) end
function M.get_formatters(conform) return H.merge_conform_fomatter_list(H.formatters(), conform) end
function M.get_debug_adapters(dap, vscode) return H.init_debug_adapters(H.debug_adapters(), dap, vscode) end

---
--- Helpers
---

function H.tools()
    return {
        lua = { 'stylua' },
        javascript = { 'prettier', 'prettierd', 'js-debug-adapter' },
    }
end

function H.parsers()
    return {
        base = { 'c', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' },
        toml = { 'toml' },
        yaml = { 'yaml' },
        json = { 'json', 'json5', 'jsonc' },
        regex = { 'regex' },
        bash = { 'bash' },
        git = { 'git_config', 'git_rebase', 'gitignore', 'gitcommit' },
        javascript = { 'javascript', 'typescript', 'tsx' },
        lua = { 'lua' },
    }
end

function H.formatters()
    return {
        markdown = { { 'prettierd', 'prettier' }, 'injected' },
        json = { 'prettierd', 'prettier' },
        jsonc = { 'prettierd', 'prettier' },
        json5 = { 'prettierd', 'prettier' },
        lua = { 'stylua' },
        typescript = { 'prettierd', 'prettier' },
        typescriptreact = { 'prettierd', 'prettier' },
        javascript = { 'prettierd', 'prettier' },
        javascriptreact = { 'prettierd', 'prettier' },
    }
end

function H.servers()
    return {
        javascript = {
            eslint = { settings = { format = false } },
            vtsls = {
                settings = {
                    typescript = {
                        suggest = { completeFunctionCalls = true },
                        inlayHints = {
                            functionLikeReturnTypes = { enabled = true },
                            parameterNames = { enabled = 'literals' },
                            variableTypes = { enabled = true },
                        },
                    },
                    javascript = {
                        suggest = { completeFunctionCalls = true },
                        inlayHints = {
                            functionLikeReturnTypes = { enabled = true },
                            parameterNames = { enabled = 'literals' },
                            variableTypes = { enabled = true },
                        },
                    },
                    vtsls = {
                        enableMoveToFileCodeAction = true,
                        autoUseWorkspaceTsdk = true,
                        experimental = {
                            maxInlayHintLength = 30,
                            completion = { enableServerSideFuzzyMatch = true },
                        },
                    },
                },
            },
        },
        lua = {
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
                        diagnostics = {
                            globals = { 'vim', 'describe', 'it', 'before_each', 'after_each' },
                            disable = { 'need-check-nil' },
                            workspaceDelay = -1,
                        },
                        workspace = { ignoreSubmodules = true },
                        telemetry = { enable = false },
                    },
                },
            },
        },
    }
end

function H.debug_adapters()
    return {
        javascript = function(dap, vscode)
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
        end,
    }
end

function H.list_extend(data)
    local res = {}
    for _, v in pairs(data) do
        vim.list_extend(res, v)
    end
    return res
end

function H.tbl_extend(data)
    local res = {}
    for _, v in pairs(data) do
        res = vim.tbl_deep_extend('force', res, v)
    end
    return res
end

function H.merge_conform_fomatter_list(list, conform)
    local function first_conform_formatter(buf, ...)
        for i = 1, select('#', ...) do
            local fmt = select(i, ...)
            if conform.get_formatter_info(fmt, buf).available then return fmt end
        end
        return select(1, ...)
    end

    local unpack = unpack or table.unpack

    local res = {}
    for k, v in pairs(list) do
        local args = vim.deepcopy(v)
        local first_arg = table.remove(args, 1)
        local other_args = args

        if type(first_arg) == 'table' then
            res[k] = function(buf) return { first_conform_formatter(buf, unpack(first_arg)), unpack(other_args) } end
        else
            v.stop_after_first = true
            res[k] = v
        end
    end
    return res
end

function H.init_debug_adapters(list, dap, vscode)
    for _, v in pairs(list) do
        v(dap, vscode)
    end
end

return M
