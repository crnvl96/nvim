local M = {
    servers = {
        vtsls = {},
        clojure_lsp = {},
        lua_ls = {
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                            '${3rd}/luv/library',
                            '${3rd}/busted/library',
                        },
                    },
                },
            },
        },
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
    },
    ts_parsers = {
        'bash',
        'c',
        'lua',
        'query',
        'fennel',
        'clojure',
        'vim',
        'vimdoc',
        'markdown',
        'markdown_inline',
        'html',
        'typescript',
        'javascript',
        'go',
        'gomod',
        'gosum',
        'gowork',
        'gotmpl',
    },
    formatters = {
        'stylua',
        'prettierd',
        'staticcheck',
        'gofumpt',
        'goimports',
        'golines',
        'joker',
    },
    debuggers = {
        'delve',
        'js-debug-adapter',
    },
}

return M
