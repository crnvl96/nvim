MiniDeps.add('williamboman/mason-lspconfig.nvim')
MiniDeps.add('neovim/nvim-lspconfig')
MiniDeps.add('stevearc/conform.nvim')
MiniDeps.add({
    source = 'williamboman/mason.nvim',
    hooks = { post_checkout = function() vim.cmd('MasonUpdate') end },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local capabilities = vim.lsp.protocol.make_client_capabilities()
local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
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

local function get_first_formatter(buffer, ...)
    for i = 1, select('#', ...) do
        local formatter = select(i, ...)
        if require('conform').get_formatter_info(formatter, buffer).available then return formatter end
    end

    return select(1, ...)
end

local keycode = vim.keycode or function(x) return vim.api.nvim_replace_termcodes(x, true, true, true) end
local keys = {
    ['cr'] = keycode('<CR>'),
    ['ctrl-y'] = keycode('<C-y>'),
    ['ctrl-y_cr'] = keycode('<C-y><CR>'),
}

local function CR_Action()
    if vim.fn.pumvisible() ~= 0 then
        local item_selected = vim.fn.complete_info()['selected'] ~= -1
        return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
    else
        return keys['cr']
    end
end

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

require('mason').setup()

require('mason-registry').refresh(function()
    for _, tool in ipairs({
        'stylua',
        'prettierd',
        'js-debug-adapter',
        'debugpy',
        'black',
    }) do
        local pkg = require('mason-registry').get_package(tool)
        if not pkg:is_installed() then pkg:install() end
    end
end)

require('mini.completion').setup({
    delay = { completion = 100, info = 100, signature = 50 },
    lsp_completion = {
        source_func = 'omnifunc',
        auto_setup = false,
        process_items = function(items, base)
            -- Don't show 'Text' and 'Snippet' suggestions
            return require('mini.completion').default_process_items(
                vim.tbl_filter(function(el) return el.kind ~= 1 and el.kind ~= 15 end, items),
                base
            )
        end,
    },
    window = {
        info = { border = 'double' },
        signature = { border = 'double' },
    },
    mappings = {
        force_twostep = '<C-n>',
        force_fallback = '<A-n>',
    },
})

require('conform').setup({
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

if vim.fn.has('nvim-0.11') == 1 then vim.opt.completeopt:append('fuzzy') end

vim.keymap.set('i', '<CR>', CR_Action, { expr = true })
