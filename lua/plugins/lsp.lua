local deps = require('mini.deps')
local add = deps.add

add('williamboman/mason-lspconfig.nvim')
add('neovim/nvim-lspconfig')
add('stevearc/conform.nvim')
add('hrsh7th/cmp-nvim-lsp')
add('hrsh7th/cmp-path')
add('hrsh7th/cmp-buffer')
add('hrsh7th/cmp-nvim-lua')
add('hrsh7th/nvim-cmp')

local conform = require('conform')
local function get_first_formatter(buffer, ...)
    for i = 1, select('#', ...) do
        local formatter = select(i, ...)
        if conform.get_formatter_info(formatter, buffer).available then return formatter end
    end

    return select(1, ...)
end

conform.setup({
    notify_on_error = false,
    formatters_by_ft = {
        markdown = function(buf) return { get_first_formatter(buf, 'prettierd', 'prettier'), 'injected' } end,
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        json5 = { 'prettierd', 'prettier', stop_after_first = true },
        lua = { 'stylua' },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
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
})

local cmp = require('cmp')
cmp.setup({
    snippet = { expand = function(args) vim.snippet.expand(args.body) end },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sorting = require('cmp.config.default')().sorting,
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
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

local function on_attach(client, bufnr)
    local m = vim.lsp.protocol.Methods
    local map = function(method, lhs, rhs, desc, mode)
        local sup = client.supports_method(method)
        local setmap = function() vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr }) end

        if sup then setmap() end
    end

    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    map(m.textDocument_definition, 'gd', "<cmd>Pick lsp scope='definition'<CR>", 'Go to definition')
    map(m.textDocument_references, 'gR', "<cmd>Pick lsp scope='references'<CR>", 'List references')
    map(m.textDocument_implementation, 'gi', "<cmd>Pick lsp scope='implementation'<CR>", 'List implementations')
    map(m.textDocument_typeDefinition, 'gy', "<cmd>Pick lsp scope='type_definition'<CR>", 'Go to type definition')
    map(m.textDocument_codeAction, 'gy', vim.lsp.buf.code_action, 'List code actions')
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
    map(m.textDocument_signatureHelp, '<C-k>', function()
        local cmp = require('cmp')
        if cmp.visible() then cmp.close() end

        vim.lsp.buf.signature_help()
    end, 'Signature help', 'i')
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
