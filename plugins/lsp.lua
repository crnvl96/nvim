local function on_attach(client, bufnr)
    local m = vim.lsp.protocol.Methods
    local map = function(method, lhs, rhs, desc, mode)
        local sup = client.supports_method(method)
        local setmap = function() vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr }) end

        if sup then setmap() end
    end

    vim.o.omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

    map(m.textDocument_definition, 'gd', "<cmd>Pick lsp scope='definition'<CR>", 'Go to definition')
    map(m.textDocument_references, 'gR', "<cmd>Pick lsp scope='references'<CR>", 'List references')
    map(m.textDocument_implementation, 'gi', "<cmd>Pick lsp scope='implementation'<CR>", 'List implementations')
    map(m.textDocument_typeDefinition, 'gy', "<cmd>Pick lsp scope='type_definition'<CR>", 'Go to type definition')
    map(m.textDocument_codeAction, 'ga', vim.lsp.buf.code_action, 'List code actions')
    map(m.textDocument_rename, 'gn', vim.lsp.buf.rename, 'Rename symbol under cursor')
    map(m.workspace_diagnostics, '<Leader>fd', '<cmd>Pick diagnostic<CR>', 'List workspace diagnostics')
    map(m.document_symbol, '<Leader>fs', "<cmd>Pick lsp scope='document_symbol'<CR>", 'List document symbols')
    map(m.workspace_symbol, '<Leader>fS', "<cmd>Pick lsp scope='workspace_symbol'<CR>", 'List workspace symbols')

    map(
        m.textDocument_inlayHint,
        '<Leader>ci',
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr }) end,
        'Toggle inlay hints'
    )
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

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
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = vim.split(package.path, ';'),
                },
                diagnostics = {
                    -- Get the language server to recognize common globals
                    globals = { 'vim', 'describe', 'it', 'before_each', 'after_each' },
                    disable = { 'need-check-nil' },
                    -- Don't make workspace diagnostic, as it consumes too much CPU and RAM
                    workspaceDelay = -1,
                },
                workspace = {
                    -- Don't analyze code from submodules
                    ignoreSubmodules = true,
                },
                -- Do not send telemetry data containing a randomized but unique identifier
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
