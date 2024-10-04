return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'williamboman/mason-lspconfig.nvim' },
            { 'williamboman/mason.nvim', build = ':MasonUpdate' },
        },
        opts = {
            ensure_installed = {
                'stylua',
                'prettierd',
                'js-debug-adapter',
                'debugpy',
                'black',
            },
            servers = {
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
            },
            capabilities = function()
                return vim.tbl_deep_extend(
                    'force',
                    {},
                    vim.lsp.protocol.make_client_capabilities(),
                    require('cmp_nvim_lsp').default_capabilities()
                )
            end,
        },
        config = function(_, opts)
            vim.diagnostic.config({
                virtual_text = {
                    prefix = '',
                    spacing = 2,
                    format = function(diagnostic)
                        return string.format(
                            '%s %s[%s] ',
                            vim.g.diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]],
                            diagnostic.source,
                            diagnostic.code
                        )
                    end,
                },
                float = {
                    border = 'rounded',
                    source = 'if_many',
                    prefix = function(diag)
                        local level = vim.diagnostic.severity[diag.severity]
                        return string.format(' %s ', vim.g.diagnostic_icons[level]),
                            'Diagnostic' .. level:gsub('^%l', string.upper)
                    end,
                },
                signs = false,
            })

            local mason = require('mason')
            local mr = require('mason-registry')

            mason.setup()
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
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then p:install() end
                end
            end)

            local mason_lspconfig = require('mason-lspconfig')
            local lspconfig = require('lspconfig')

            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(opts.servers),
                handlers = {
                    function(server_name)
                        local server = opts.servers[server_name] or {}
                        server.capabilities = opts.capabilities()
                        lspconfig[server_name].setup(server)
                    end,
                },
            })
        end,
    },
}
