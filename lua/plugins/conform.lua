MiniDeps.add({
    source = 'stevearc/conform.nvim',
    depends = { { source = 'williamboman/mason.nvim' } },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local conform = require('conform')

conform.setup({
    notify_on_error = false,
    formatters_by_ft = Lang.get_formatters(conform),
    formatters = { injected = { options = { ignore_errors = true } } },
    format_on_save = { timeout_ms = 1000, lsp_format = 'fallback' },
})
