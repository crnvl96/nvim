MiniDeps.add({ source = 'stevearc/conform.nvim' })

local conform = require('conform')

local function first(buf, ...)
    for i = 1, select('#', ...) do
        local formatter = select(i, ...)
        if conform.get_formatter_info(formatter, buf).available then return formatter end
    end

    return select(1, ...)
end

conform.setup({
    notify_on_error = false,
    formatters_by_ft = {
        lua = { 'stylua' },
        clojure = { 'joker' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        ['javascript.jsx'] = { 'prettierd', 'prettier', stop_after_first = true },
        ['typescript.tsx'] = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        json5 = { 'prettierd', 'prettier', stop_after_first = true },
        go = { 'gofumpt', 'goimports', 'golines' },
        markdown = function(buf) return { first(buf, 'prettierd', 'prettier'), 'injected' } end,
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
