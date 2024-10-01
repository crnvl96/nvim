return {
    { 'williamboman/mason-lspconfig.nvim' },
    { 'williamboman/mason.nvim', build = ':MasonUpdate' },
    -- {
    --     'hrsh7th/nvim-cmp',
    --     event = 'InsertEnter',
    --     dependencies = {
    --         'hrsh7th/cmp-path',
    --         'hrsh7th/cmp-buffer',
    --         'hrsh7th/cmp-nvim-lua',
    --         'hrsh7th/cmp-nvim-lsp',
    --     },
    --     config = function()
    --         local cmp = require('cmp')
    --
    --         cmp.setup({
    --             snippet = {
    --                 expand = function(args) vim.snippet.expand(args.body) end,
    --             },
    --             window = {
    --                 completion = cmp.config.window.bordered(),
    --                 documentation = cmp.config.window.bordered(),
    --             },
    --             sorting = require('cmp.config.default')().sorting,
    --             preselect = cmp.PreselectMode.None,
    --             mapping = cmp.mapping.preset.insert({ ['<C-Space>'] = cmp.mapping.complete() }),
    --             sources = cmp.config.sources({
    --                 {
    --                     name = 'nvim_lsp',
    --                     entry_filter = function(entry)
    --                         local type = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
    --                         return type ~= 'Text' and type ~= 'Snippet'
    --                     end,
    --                 },
    --                 { name = 'nvim_lua' },
    --                 { name = 'path' },
    --                 { name = 'buffer' },
    --             }),
    --         })
    --     end,
    -- },
    {
        'echasnovski/mini.completion',
        event = 'InsertEnter',
        config = function()
            require('mini.completion').setup({
                lsp_completion = {
                    source_func = 'omnifunc',
                    auto_setup = false,
                    process_items = function(items, base)
                        items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
                        return require('mini.completion').default_process_items(items, base)
                    end,
                },
                window = {
                    info = { border = 'rounded' },
                    signature = { border = 'rounded' },
                },
                set_vim_settings = false,
            })

            if vim.fn.has('nvim-0.11') == 1 then vim.opt.completeopt:append('fuzzy,menuone,noinsert,noselect,popup') end

            local keycode = vim.keycode or function(x) return vim.api.nvim_replace_termcodes(x, true, true, true) end
            local keys = {
                ['cr'] = keycode('<CR>'),
                ['ctrl-y'] = keycode('<C-y>'),
                ['ctrl-y_cr'] = keycode('<C-y><CR>'),
            }

            _G.cr_action = function()
                if vim.fn.pumvisible() ~= 0 then
                    local item_selected = vim.fn.complete_info()['selected'] ~= -1
                    return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
                else
                    return keys['cr']
                end
            end

            vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        init = function()
            local function on_attach(client, bufnr)
                -- vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
                vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

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
                    vim.lsp.protocol.make_client_capabilities()
                    -- require('cmp_nvim_lsp').default_capabilities()
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
