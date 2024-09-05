return {
    servers = {
        vtsls = {},
        eslint = { settings = { format = false } },
        gopls = { settings = { gopls = { gofumpt = true } } },
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
    ts_parsers = {
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
    },
    formatters = {
        'stylua',
        'prettierd',
        'staticcheck',
        'gofumpt',
        'goimports',
        'golines',
    },
}
