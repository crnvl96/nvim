return {
    { 'williamboman/mason-lspconfig.nvim' },
    { 'williamboman/mason.nvim', build = ':MasonUpdate' },
    {
        'echasnovski/mini.completion',
        event = 'InsertEnter',
        config = function()
            require('mini.completion').setup({
                delay = { completion = 100, info = 100, signature = 100 },
                window = {
                    info = { height = 25, width = 80, border = 'rounded' },
                    signature = { height = 25, width = 80, border = 'rounded' },
                },
                lsp_completion = {
                    source_func = 'omnifunc',
                    auto_setup = false,
                    process_items = function(items, base)
                        items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
                        return require('mini.completion').default_process_items(items, base)
                    end,
                },
                set_vim_settings = true,
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        init = function()
            local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
            vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                if not client then return end
                require('lsp-on-attach').setup(client, vim.api.nvim_get_current_buf())
                return registerCapability(err, res, ctx)
            end
        end,
        config = function()
            require('mason').setup()

            local mr = require('mason-registry')
            mr:on('package:install:success', function()
                vim.defer_fn(
                    function()
                        require('lazy.core.handler.event').trigger({
                            event = 'FileType',
                            buf = vim.api.nvim_get_current_buf(),
                        })
                    end,
                    100
                )
            end)

            mr.refresh(function()
                for _, tool in ipairs({
                    'stylua',
                    'prettierd',
                    'js-debug-adapter',
                    'debugpy',
                    'black',
                }) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then p:install() end
                end
            end)

            local servers = {
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
                            not path
                            or not (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
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

            require('mason-lspconfig').setup({
                ensure_installed = vim.tbl_keys(servers),
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.lsp.protocol.make_client_capabilities()
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(e)
                    local client = vim.lsp.get_client_by_id(e.data.client_id)
                    if not client then return end
                    require('lsp-on-attach').setup(client, e.buf)
                end,
            })
        end,
    },
}
