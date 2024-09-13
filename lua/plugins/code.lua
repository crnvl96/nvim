local servers = {
    vtsls = {},
    eslint = {
        settings = {
            format = false,
        },
    },
    gopls = {
        settings = {
            gopls = {
                gofumpt = true,
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
}

local function first(buf, ...)
    local conform = require('conform')
    for i = 1, select('#', ...) do
        local formatter = select(i, ...)
        if conform.get_formatter_info(formatter, buf).available then return formatter end
    end

    return select(1, ...)
end

local function on_attach(client, bufnr)
    local function set(lhs, rhs, desc, mode)
        local s = vim.keymap.set
        s(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr })
    end

    client.server_capabilities.documentFormattingProvider = false
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local fzf = require('fzf-lua')

    set('grr', fzf.lsp_references, 'references')
    set('grd', fzf.lsp_definitions, 'definitions')
    set('gri', fzf.lsp_implementations, 'implementations')
    set('gry', fzf.lsp_typedefs, 'typedefs')
    set('gra', fzf.lsp_code_actions, 'code actions')
    set('grc', fzf.lsp_incoming_calls, 'incoming calls')
    set('grn', vim.lsp.buf.rename, 'rename symbol')
    set('grC', fzf.lsp_outgoing_calls, 'outgoing calls')
    set('grs', fzf.lsp_document_symbols, 'document symbols')
    set('grS', fzf.lsp_workspace_symbols, 'workspace symbols')
    set('grx', fzf.lsp_document_diagnostics, 'documet diagnostics')
    set('grX', fzf.lsp_workspace_diagnostics, 'workspace diagnostics')
    set('<C-k>', vim.lsp.buf.signature_help, 'signature help', 'i')
end

local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
)

require('cmp').setup({
    snippet = {
        expand = function(args) vim.snippet.expand(args.body) end,
    },
    sorting = require('cmp.config.default')().sorting,
    preselect = require('cmp').PreselectMode.None,
    mapping = require('cmp').mapping.preset.insert({
        ['<C-p>'] = require('cmp').mapping.select_prev_item({ behavior = require('cmp').SelectBehavior.Insert }),
        ['<C-n>'] = require('cmp').mapping.select_next_item({ behavior = require('cmp').SelectBehavior.Insert }),
        ['<C-y>'] = require('cmp').mapping.confirm({ select = true }),
        ['<C-Space>'] = require('cmp').mapping.complete(),
        ['<CR>'] = require('cmp').mapping({
            i = function(fallback)
                if require('cmp').visible() and require('cmp').get_active_entry() then
                    require('cmp').confirm({ behavior = require('cmp').ConfirmBehavior.Replace, select = false })
                else
                    fallback()
                end
            end,
        }),
    }),
    sources = require('cmp').config.sources({
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

require('conform').setup({
    notify_on_error = false,
    formatters_by_ft = {
        markdown = function(buf) return { first(buf, 'prettierd', 'prettier'), 'injected' } end,
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        json5 = { 'prettierd', 'prettier', stop_after_first = true },
        go = { 'gofumpt', 'goimports', 'golines' },
        lua = { 'stylua' },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        ['typescript.tsx'] = { 'prettierd', 'prettier', stop_after_first = true },
        ['javascript.tsx'] = { 'prettierd', 'prettier', stop_after_first = true },
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
        on_attach(client, e.buf)
    end,
})
