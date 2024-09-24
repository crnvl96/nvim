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
            return string.format(' %s ', vim.g.diagnostic_icons[level]), 'Diagnostic' .. level:gsub('^%l', string.upper)
        end,
    },
    signs = false,
})

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
            local path = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name
            if not path or not (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
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

local methods = vim.lsp.protocol.Methods
local function on_attach(client, bufnr)
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local function toggle_inlayhints()
        local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
    end

    local maps = {
        { methods.textDocument_definition, 'grd', '<cmd>FzfLua lsp_definitions<cr>', 'Definitions' },
        { methods.textDocument_references, 'grr', '<cmd>FzfLua lsp_references<cr>', 'References' },
        { methods.textDocument_implementation, 'gri', '<cmd>FzfLua lsp_implementations<cr>', 'Implementations' },
        { methods.textDocument_typeDefinition, 'gry', '<cmd>FzfLua lsp_typedefs<cr>', 'Type Definitions' },
        { methods.textDocument_codeAction, 'gra', '<cmd>FzfLua lsp_code_actions<cr>', 'Code Actions' },
        { methods.textDocument_rename, 'grn', vim.lsp.buf.rename, 'Rename Symbol' },
        { methods.textDocument_inlayHint, '<leader>ci', toggle_inlayhints, 'Toggle Inlay Hints' },
    }

    for _, map in ipairs(maps) do
        if client.supports_method(map[1]) then
            vim.keymap.set('n', map[2], map[3], { desc = map[4], buffer = bufnr })
        end
    end
end

local registerCapability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    on_attach(client, vim.api.nvim_get_current_buf())
    return registerCapability(err, res, ctx)
end

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
                        end,
                    },
                },
            },
            {
                'hrsh7th/nvim-cmp',
                event = 'InsertEnter',
                dependencies = {
                    'hrsh7th/cmp-path',
                    'hrsh7th/cmp-buffer',
                    'hrsh7th/cmp-nvim-lua',
                    'hrsh7th/cmp-nvim-lsp',
                },
                config = function()
                    local cmp = require('cmp')

                    cmp.setup({
                        snippet = {
                            expand = function(args) vim.snippet.expand(args.body) end,
                        },
                        window = {
                            completion = cmp.config.window.bordered(),
                            documentation = cmp.config.window.bordered(),
                        },
                        sorting = require('cmp.config.default')().sorting,
                        preselect = cmp.PreselectMode.None,
                        mapping = cmp.mapping.preset.insert({
                            ['<C-Space>'] = cmp.mapping.complete(),
                            ['<CR>'] = cmp.mapping({
                                i = function(fallback)
                                    if cmp.visible() and cmp.get_active_entry() then
                                        cmp.confirm({
                                            behavior = cmp.ConfirmBehavior.Replace,
                                            select = false,
                                        })
                                    else
                                        fallback()
                                    end
                                end,
                            }),
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
                    })
                end,
            },
        },
        config = function()
            local capabilities = function()
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

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(e)
                    local client = vim.lsp.get_client_by_id(e.data.client_id)
                    if not client then return end
                    on_attach(client, e.buf)
                end,
            })
        end,
    },
}
