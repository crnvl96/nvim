local tools = require('config.tools')

tools.servers.lua_ls = {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME, '${3rd}/luv/library', '${3rd}/busted/library' },
            },
        },
    },
}

vim.list_extend(tools.ts_parsers, { 'lua' })

vim.list_extend(tools.formatters, { 'stylua' })

tools.conform_by_ft.lua = { 'stylua' }
