return {
    { 'hrsh7th/cmp-nvim-lsp' },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            dependencies = {
                'williamboman/mason.nvim',
                build = ':MasonUpdate',
                opts = function()
                    return {
                        ensure_installed = {
                            'stylua',
                            'prettierd',
                            'js-debug-adapter',
                        },
                    }
                end,
                config = function(_, opts)
                    require('mason').setup()

                    local mr = require('mason-registry')
                    mr:on('package:install:success', function()
                        vim.defer_fn(function()
                            -- trigger FileType event to possibly load this newly installed LSP server
                            require('lazy.core.handler.event').trigger({
                                event = 'FileType',
                                buf = vim.api.nvim_get_current_buf(),
                            })
                        end, 100)
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
        opts = function()
            return {
                servers = {
                    vtsls = {},
                    eslint = {
                        settings = {
                            format = false,
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
                on_attach = function(client, bufnr)
                    local function set(lhs, rhs, desc, mode)
                        local s = vim.keymap.set
                        s(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr })
                    end

                    client.server_capabilities.documentFormattingProvider = false
                    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    set('grr', function() require('fzf-lua').lsp_references() end, 'references')
                    set('grd', function() require('fzf-lua').lsp_definitions() end, 'definitions')
                    set('gri', function() require('fzf-lua').lsp_implementations() end, 'implementations')
                    set('gry', function() require('fzf-lua').lsp_typedefs() end, 'typedefs')
                    set('gra', function() require('fzf-lua').lsp_code_actions() end, 'code actions')
                    set('grn', vim.lsp.buf.rename, 'rename symbol')
                    set('grc', function() require('fzf-lua').lsp_incoming_calls() end, 'incoming calls')
                    set('grC', function() require('fzf-lua').lsp_outgoing_calls() end, 'outgoing calls')
                    set('grs', function() require('fzf-lua').lsp_document_symbols() end, 'document symbols')
                    set('grS', function() require('fzf-lua').lsp_workspace_symbols() end, 'workspace symbols')
                    set('grx', function() require('fzf-lua').lsp_document_diagnostics() end, 'document diagnostics')
                    set('grX', function() require('fzf-lua').lsp_workspace_diagnostics() end, 'workspace diagnostics')

                    set('<C-k>', vim.lsp.buf.signature_help, 'signature help', 'i')

                    set('<C-x>r', function() vim.lsp.buf.references() end, 'references')
                    set('<C-x>d', function() vim.lsp.buf.definition() end, 'definitions')
                    set('<C-x>i', function() vim.lsp.buf.implementation() end, 'implementations')
                    set('<C-x>y', function() vim.lsp.buf.type_definition() end, 'typedefs')
                    set('<C-x>a', function() vim.lsp.buf.code_action() end, 'code actions')
                    set('<C-x>n', vim.lsp.buf.rename, 'rename symbol')
                    set('<C-x>c', function() vim.lsp.buf.incoming_calls() end, 'incoming calls')
                    set('<C-x>C', function() vim.lsp.buf.outgoing_calls() end, 'outgoing calls')
                    set('<C-x>s', function() vim.lsp.buf.document_symbol() end, 'document symbols')
                    set('<C-x>S', function() vim.lsp.buf.workspace_symbol() end, 'workspace symbols')
                    set('<C-x>x', function() vim.diagnostic.show() end, 'document diagnostics')
                    set('<C-x>X', function() vim.diagnostic.setqflist() end, 'document diagnostics')
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
