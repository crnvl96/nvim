local add = MiniDeps.add
local tools = require('config.tools')

add({ source = 'stevearc/conform.nvim' })

local conform = require('conform')

conform.setup({
    notify_on_error = false,
    formatters_by_ft = tools.conform_by_ft,
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
