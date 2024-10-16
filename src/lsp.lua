require('mason').setup()

require('mason-registry').refresh(function()
    for _, tool in ipairs({
        'stylua',
        'prettierd',
        'js-debug-adapter',
    }) do
        local pkg = require('mason-registry').get_package(tool)
        if not pkg:is_installed() then pkg:install() end
    end
end)

local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
)

local servers = {
    eslint = { settings = { format = false } },
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

local on_lsp_attach = function(client, bufnr)
    local map = function(method, lhs, rhs, desc, mode)
        local setmap = function() vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr }) end
        if client.supports_method(method) then setmap() end
    end

    local methods = vim.lsp.protocol.Methods

    local wrap = function(mod) return require('telescope.builtin')[mod](require('telescope.themes').get_ivy()) end

    map(methods.textDocument_codeAction, 'ga', vim.lsp.buf.code_action, 'List code actions')
    map(methods.textDocument_rename, 'gn', vim.lsp.buf.code_action, 'Rename symbol under cursor')
    map(methods.document_symbol, 'gs', function() wrap('lsp_document_symbols') end, 'List document symbols')
    map(methods.document_symbol, 'gS', function() wrap('lsp_workspace_symbols') end, 'List workspace symbols')
    map(methods.textDocument_definition, 'gd', function() wrap('lsp_definitions') end, 'Go to definition')
    map(methods.textDocument_references, 'gR', function() wrap('lsp_references') end, 'List references')
        -- stylua: ignore
        map(methods.textDocument_implementation, 'gi', function() wrap('lsp_implementations') end, 'List implementations')
    map(methods.textDocument_typeDefinition, 'gy', function() wrap('type_definitions') end, 'Go to type definition')
    map(methods.workspace_diagnostics, 'gx', function() wrap('diagnostics') end, 'List document diagnostics')
end

local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    on_lsp_attach(client, vim.api.nvim_get_current_buf())
    return registerCapability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('Crnvl96LspOnAttach', {}),
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        on_lsp_attach(client, e.buf)
    end,
})
