return {
    { 'williamboman/mason-lspconfig.nvim' },
    { 'williamboman/mason.nvim', build = ':MasonUpdate' },
    { 'hrsh7th/cmp-nvim-lsp' },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lua',
        },
        opts = function()
            local cmp = require('cmp')
            local defaults = require('cmp.config.default')()

            local function cmp_CR_action()
                return {
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
                }
            end

            local function cmp_lsp_entry_filter(entry)
                local type = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
                return type ~= 'Text' and type ~= 'Snippet'
            end

            return {
                snippet = {
                    expand = function(args) vim.snippet.expand(args.body) end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                sorting = defaults.sorting,
                preselect = cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping(cmp_CR_action()),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp', entry_filter = cmp_lsp_entry_filter },
                    { name = 'nvim_lua' },
                    { name = 'path' },
                    { name = 'buffer' },
                }),
            }
        end,
        config = function(_, opts) require('cmp').setup(opts) end,
    },
    {
        'stevearc/conform.nvim',
        event = 'BufWritePre',
        opts = function()
            local function get_first_formatter(buf, ...)
                for i = 1, select('#', ...) do
                    local formatter = select(i, ...)
                    if require('conform').get_formatter_info(formatter, buf).available then return formatter end
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
                    --
                    typescript = { 'prettierd', 'prettier', stop_after_first = true },
                    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
                    javascript = { 'prettierd', 'prettier', stop_after_first = true },
                    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
                    --
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
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = function()
            return {
                ensure_installed = {
                    'stylua',
                    'prettierd',
                    'js-debug-adapter',
                    'debugpy',
                    'black',
                },
                servers = {
                    basedpyright = {},
                    eslint = { settings = { format = false } },
                    vtsls = {
                        settings = {
                            complete_function_calls = true,
                            vtsls = {
                                enableMoveToFileCodeAction = true,
                                autoUseWorkspaceTsdk = true,
                                experimental = {
                                    completion = {
                                        enableServerSideFuzzyMatch = true,
                                    },
                                },
                            },
                            typescript = {
                                updateImportsOnFileMove = { enabled = 'always' },
                                suggest = {
                                    completeFunctionCalls = true,
                                },
                            },
                        },
                    },
                    lua_ls = {
                        settings = {
                            Lua = {
                                runtime = { version = 'LuaJIT' },
                                workspace = {
                                    checkThirdParty = false,
                                    library = { vim.env.VIMRUNTIME, '${3rd}/luv/library', '${3rd}/busted/library' },
                                },
                            },
                        },
                    },
                },
                on_attach = function(_, bufnr)
                    local function set(lhs, rhs, desc, mode)
                        vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr })
                    end

                    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    set('grr', function() require('fzf-lua').lsp_references() end, 'references')
                    set('grd', function() require('fzf-lua').lsp_definitions() end, 'definitions')
                    set('gri', function() require('fzf-lua').lsp_implementations() end, 'implementations')
                    set('gry', function() require('fzf-lua').lsp_typedefs() end, 'typedefs')
                    set('gra', function() require('fzf-lua').lsp_code_actions() end, 'code actions')
                    set('grc', function() require('fzf-lua').lsp_incoming_calls() end, 'incoming calls')
                    set('grC', function() require('fzf-lua').lsp_outgoing_calls() end, 'outgoing calls')
                    set('grs', function() require('fzf-lua').lsp_document_symbols() end, 'document symbols')
                    set('grS', function() require('fzf-lua').lsp_workspace_symbols() end, 'workspace symbols')
                    set('grx', function() require('fzf-lua').lsp_document_diagnostics() end, 'document diagnostics')
                    set('grX', function() require('fzf-lua').lsp_workspace_diagnostics() end, 'workspace diagnostics')

                    set('grn', vim.lsp.buf.rename, 'rename symbol')
                    set('<C-k>', vim.lsp.buf.signature_help, 'signature help', 'i')
                end,
                capabilities = function()
                    return vim.tbl_deep_extend(
                        'force',
                        {},
                        vim.lsp.protocol.make_client_capabilities(),
                        require('cmp_nvim_lsp').default_capabilities()
                    )
                end,
            }
        end,
        config = function(_, opts)
            local servers = opts.servers
            local capabilities = opts.capabilities()

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
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then p:install() end
                end
            end)

            require('mason-lspconfig').setup({
                ensure_installed = vim.tbl_keys(servers),
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = capabilities
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(e)
                    local client = vim.lsp.get_client_by_id(e.data.client_id)
                    if not client then return end
                    opts.on_attach(client, e.buf)
                end,
            })
        end,
    },
}
