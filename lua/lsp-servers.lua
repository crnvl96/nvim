local M = {}

function M.setup()
    return {
        eslint = { settings = { format = false } },
        basedpyright = {},
        ruff = {
            cmd_env = { RUFF_TRACE = 'messages' },
            init_options = {
                settings = {
                    logLevel = 'error',
                },
            },
        },
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
                        completion = {
                            enableServerSideFuzzyMatch = true,
                        },
                    },
                },
            },
        },
        lua_ls = {
            on_init = function(client)
                local path = client.workspace_folders
                    and client.workspace_folders[1]
                    and client.workspace_folders[1].name
                if
                    not path or not (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                    client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                        Lua = {
                            runtime = {
                                version = 'LuaJIT',
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME,
                                    '${3rd}/luv/library',
                                },
                            },
                        },
                    })
                    client.notify(
                        vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
                        { settings = client.config.settings }
                    )
                end

                return true
            end,
            settings = {
                Lua = {
                    format = { enable = false },
                    hint = {
                        enable = true,
                        arrayIndex = 'Disable',
                    },
                    completion = { callSnippet = 'Replace' },
                },
            },
        },
    }
end

return M
