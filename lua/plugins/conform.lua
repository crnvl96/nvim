return {
    {
        'stevearc/conform.nvim',
        event = 'BufWritePre',
        opts = function()
            local conform = require('conform')

            local function get_first_formatter(buf, ...)
                for i = 1, select('#', ...) do
                    local formatter = select(i, ...)
                    if conform.get_formatter_info(formatter, buf).available then return formatter end
                end

                return select(1, ...)
            end

            local formatters_by_ft = {
                markdown = function(buf) return { get_first_formatter(buf, 'prettierd', 'prettier'), 'injected' } end,
                json = { 'prettierd', 'prettier', stop_after_first = true },
                jsonc = { 'prettierd', 'prettier', stop_after_first = true },
                json5 = { 'prettierd', 'prettier', stop_after_first = true },
                lua = { 'stylua' },
            }

            for _, ft in ipairs({
                'typescript',
                'typescriptreact',
                'typescript.tsx',
                'javascript',
                'javascriptreact',
                'javascript.tsx',
            }) do
                formatters_by_ft[ft] = { 'prettierd', 'prettier', stop_after_first = true }
            end

            return {
                notify_on_error = false,
                formatters_by_ft = formatters_by_ft,
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
            }
        end,
        config = function(_, opts) require('conform').setup(opts) end,
    },
}
