MiniDeps.add({
    source = 'neovim/nvim-lspconfig',
    depends = {
        {
            source = 'williamboman/mason-lspconfig.nvim',
            depends = {
                { source = 'williamboman/mason.nvim' },
            },
        },
    },
})

local servers = {
    eslint = {
        settings = {
            format = false,
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
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = vim.split(package.path, ';'),
                },
                diagnostics = {
                    globals = { 'vim', 'describe', 'it', 'before_each', 'after_each' },
                    disable = { 'need-check-nil' },
                    workspaceDelay = -1,
                },
                workspace = {
                    ignoreSubmodules = true,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()

local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    On_lsp_attach(client, vim.api.nvim_get_current_buf())
    return registerCapability(err, res, ctx)
end

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
    group = vim.api.nvim_create_augroup('Crnvl96LspOnAttach', {}),
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        On_lsp_attach(client, e.buf)
    end,
})
