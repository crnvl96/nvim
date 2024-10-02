return {
    { 'williamboman/mason-lspconfig.nvim' },
    { 'williamboman/mason.nvim', build = ':MasonUpdate' },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        init = function()
            local function on_attach(client, bufnr)
                vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

                local function toggle_inlayhints()
                    local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                    vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
                end

                local definitions = vim.lsp.protocol.Methods.textDocument_definition
                local references = vim.lsp.protocol.Methods.textDocument_references
                local implementations = vim.lsp.protocol.Methods.textDocument_implementation
                local typeDefinition = vim.lsp.protocol.Methods.textDocument_typeDefinition
                local document_symbol = vim.lsp.protocol.Methods.textDocument_documentSymbol
                local workspace_symbol = vim.lsp.protocol.Methods.workspace_symbol
                local diagnostics = vim.lsp.protocol.Methods.textDocument_diagnostic

                local codeAction = vim.lsp.protocol.Methods.textDocument_codeAction
                local renameSymbol = vim.lsp.protocol.Methods.textDocument_rename
                local inlayHint = vim.lsp.protocol.Methods.textDocument_inlayHint

                local maps = {
                    { definitions, 'grd', "<cmd>Pick lsp scope='definition'<CR>", 'Definitions' },
                    { references, 'grr', "<cmd>Pick lsp scope='references'<CR>", 'References' },
                    { implementations, 'gri', "<cmd>Pick lsp scope='implementation'<CR>", 'Implementations' },
                    { typeDefinition, 'gry', "<cmd>Pick lsp scope='type_definition'<CR>", 'Type Definitions' },
                    { typeDefinition, 'gry', "<cmd>Pick lsp scope='type_definition'<CR>", 'Type Definitions' },
                    { document_symbol, 'grs', "<cmd>Pick lsp scope='document_symbol'<CR>", 'Document Symbol' },
                    { workspace_symbol, 'grS', "<cmd>Pick lsp scope='workspace_symbol'<CR>", 'Workspace Symbol' },
                    { diagnostics, 'grx', vim.diagnostic.setqflist, 'Diagnostics' },
                    { diagnostics, 'grX', vim.diagnostic.setqflist, 'Diagnostics' },
                    { codeAction, 'gra', vim.lsp.buf.code_action, 'Code Actions' },
                    { renameSymbol, 'grn', vim.lsp.buf.rename, 'Rename Symbol' },
                    { inlayHint, '<leader>ci', toggle_inlayhints, 'Toggle Inlay Hints' },
                }

                for _, map in ipairs(maps) do
                    if client.supports_method(map[1]) then
                        vim.keymap.set('n', map[2], map[3], { desc = map[4], buffer = bufnr })
                    end
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

            local function capabilities()
                return vim.tbl_deep_extend(
                    'force',
                    {},
                    vim.lsp.protocol.make_client_capabilities(),
                    require('cmp_nvim_lsp').default_capabilities()
                )
            end

            require('mason-lspconfig').setup({
                ensure_installed = vim.tbl_keys(servers),
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = capabilities()
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            })
        end,
    },
}
