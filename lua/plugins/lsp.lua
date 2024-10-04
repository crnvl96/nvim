return {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'williamboman/mason.nvim', build = ':MasonUpdate' },
    {
        'stevearc/conform.nvim',
        event = 'BufWritePre',
        opts = function()
            local conform = require('conform')

            local function get_first_formatter(buffer, ...)
                for i = 1, select('#', ...) do
                    local formatter = select(i, ...)
                    if conform.get_formatter_info(formatter, buffer).available then return formatter end
                end

                return select(1, ...)
            end

            return {
                notify_on_error = false,
                formatters_by_ft = {
                    markdown = function(buf) return { get_first_formatter(buf, 'prettierd', 'prettier'), 'injected' } end,
                    json = { 'prettierd', 'prettier', stop_after_first = true },
                    jsonc = { 'prettierd', 'prettier', stop_after_first = true },
                    json5 = { 'prettierd', 'prettier', stop_after_first = true },
                    lua = { 'stylua' },
                    typescript = { 'prettierd', 'prettier', stop_after_first = true },
                    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
                    javascript = { 'prettierd', 'prettier', stop_after_first = true },
                    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
                    python = { 'black' },
                },
                formatters = {
                    injected = {
                        options = {
                            ignore_errors = true,
                        },
                    },
                },
                format_on_save = {
                    timeout_ms = 1000,
                    lsp_format = 'fallback',
                },
            }
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter' },
        dependencies = {
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lua',
        },
        opts = function()
            local cmp = require('cmp')

            return {
                snippet = { expand = function(args) vim.snippet.expand(args.body) end },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                sorting = require('cmp.config.default')().sorting,
                preselect = cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    {
                        name = 'nvim_lsp',
                        entry_filter = function(entry)
                            local type = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
                            return type ~= 'Text' and type ~= 'Snippet'
                        end,
                    },
                    { name = 'nvim_lua' },
                    { name = 'path' },
                    { name = 'buffer' },
                }),
            }
        end,
        config = function(_, opts)
            local cmp = require('cmp')
            cmp.setup(opts)
        end,
    },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
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
