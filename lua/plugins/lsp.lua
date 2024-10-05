local deps = require('mini.deps')
local add = deps.add

add('williamboman/mason-lspconfig.nvim')
add('neovim/nvim-lspconfig')

local function on_attach(client, bufnr)
    local set = vim.keymap.set
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
        set('n', 'gd', "<cmd>Pick lsp scope='definition'<CR>", { desc = 'Lsp: go to definitions', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_references) then
        local cmd = "<cmd>Pick lsp scope='references'<CR>"
        set('n', 'gR', cmd, { desc = 'Lsp: go to references', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_implementation) then
        local cmd = "<cmd>Pick lsp scope='implementation'<CR>"
        set('n', 'gi', cmd, { desc = 'Lsp: go to implementations', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_typeDefinition) then
        local cmd = "<cmd>Pick lsp scope='type_definition'<CR>"
        set('n', 'gy', cmd, { desc = 'Lsp: go to type definition', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
        set('n', 'ga', function() vim.lsp.buf.code_action() end, { desc = 'Lsp: code actions', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
        local cmd = function() vim.lsp.buf.rename() end
        set('n', 'gn', cmd, { desc = 'Lsp: rename symbol under cursor', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.workspace_diagnostic) then
        set('n', '<leader>fd', '<cmd>Pick diagnostic<CR>', { desc = 'Lsp: Pick diagnostics', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.document_symbol) then
        local cmd = "<cmd>Pick lsp scope='document_symbol'<CR>"
        set('n', '<leader>fs', cmd, { desc = 'Lsp: Pick document symbols', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.workspace_symbol) then
        local cmd = "<cmd>Pick lsp scope='workspace_symbol'<CR>"
        set('n', '<leader>fS', cmd, { desc = 'Lsp: Pick workspace symbols', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        local cmd = function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end

        vim.keymap.set('n', '<leader>ci', cmd, { desc = 'Lsp: toggle inlay hints', buffer = bufnr })
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

local capabilities = function()
    return vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
    )
end

local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')

mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(servers),
    handlers = {
        function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = capabilities()
            lspconfig[server_name].setup(server)
        end,
    },
})
