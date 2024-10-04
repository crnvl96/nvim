return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            {
                'williamboman/mason-lspconfig.nvim',
                dependencies = {
                    {
                        'williamboman/mason.nvim',
                        build = ':MasonUpdate',
                        opts = {
                            ensure_installed = {
                                'stylua',
                                'prettierd',
                                'js-debug-adapter',
                                'debugpy',
                                'black',
                            },
                        },
                        config = function(_, opts)
                            require('mason').setup(opts)

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
                                for _, tool in ipairs(opts.ensure_installed) do
                                    local p = mr.get_package(tool)
                                    if not p:is_installed() then p:install() end
                                end
                            end)
                        end,
                    },
                },
            },
        },
        init = function()
            local function on_attach(client, bufnr)
                vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

                if client.supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
                    vim.keymap.set(
                        'n',
                        'gd',
                        "<cmd>Pick lsp scope='definition'<CR>",
                        { desc = 'Lsp: go to definitions', buffer = bufnr }
                    )
                end

                if client.supports_method(vim.lsp.protocol.Methods.textDocument_references) then
                    vim.keymap.set(
                        'n',
                        'gr',
                        "<cmd>Pick lsp scope='references'<CR>",
                        { desc = 'Lsp: go to references', buffer = bufnr }
                    )
                end

                if client.supports_method(vim.lsp.protocol.Methods.textDocument_implementation) then
                    vim.keymap.set(
                        'n',
                        'gi',
                        "<cmd>Pick lsp scope='implementation'<CR>",
                        { desc = 'Lsp: go to implementations', buffer = bufnr }
                    )
                end

                if client.supports_method(vim.lsp.protocol.Methods.textDocument_typeDefinition) then
                    vim.keymap.set(
                        'n',
                        'gy',
                        "<cmd>Pick lsp scope='type_definition'<CR>",
                        { desc = 'Lsp: go to type definition', buffer = bufnr }
                    )
                end

                if client.supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
                    vim.keymap.set(
                        'n',
                        'ga',
                        function() vim.lsp.buf.code_action() end,
                        { desc = 'Lsp: code actions', buffer = bufnr }
                    )
                end

                if client.supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
                    vim.keymap.set(
                        'n',
                        'gn',
                        function() vim.lsp.buf.rename() end,
                        { desc = 'Lsp: rename symbol under cursor', buffer = bufnr }
                    )
                end

                if client.supports_method(vim.lsp.protocol.Methods.workspace_diagnostic) then
                    vim.keymap.set(
                        'n',
                        '<leader>fd',
                        '<cmd>Pick diagnostic<CR>',
                        { desc = 'Lsp: Pick diagnostics', buffer = bufnr }
                    )
                end

                if client.supports_method(vim.lsp.protocol.Methods.document_symbol) then
                    vim.keymap.set(
                        'n',
                        '<leader>fs',
                        "<cmd>Pick lsp scope='document_symbol'<CR>",
                        { desc = 'Lsp: Pick document symbols', buffer = bufnr }
                    )
                end

                if client.supports_method(vim.lsp.protocol.Methods.workspace_symbol) then
                    vim.keymap.set(
                        'n',
                        '<leader>fS',
                        "<cmd>Pick lsp scope='workspace_symbol'<CR>",
                        { desc = 'Lsp: Pick workspace symbols', buffer = bufnr }
                    )
                end

                if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    vim.keymap.set('n', '<leader>ci', function()
                        local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                        vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
                    end, { desc = 'Lsp: toggle inlay hints', buffer = bufnr })
                end
            end

            local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
            vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                if not client then return end
                on_attach(client, vim.api.nvim_get_current_buf())
                return registerCapability(err, res, ctx)
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(e)
                    local client = vim.lsp.get_client_by_id(e.data.client_id)
                    if not client then return end
                    on_attach(client, e.buf)
                end,
            })
        end,
        opts = {
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

            require('mason-lspconfig').setup({
                ensure_installed = vim.tbl_keys(opts.servers),
                handlers = {
                    function(server_name)
                        local server = opts.servers[server_name] or {}
                        server.capabilities = opts.capabilities()
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            })
        end,
    },
}
