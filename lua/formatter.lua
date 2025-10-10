local util = require 'util.formatter'
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.autoformat = true

require('conform').setup {
    notify_on_error = false,
    notify_no_formatters = false,
    formatters = {
        prettier = { require_cwd = false },
    },
    formatters_by_ft = {
        go = { name = 'gopls', timeout_ms = 500, lsp_format = 'prefer' },
        javascript = { 'prettierd', timeout_ms = 500, lsp_format = 'fallback' },
        javascriptreact = { 'prettierd', timeout_ms = 500, lsp_format = 'fallback' },
        typescript = { 'prettierd', timeout_ms = 500, lsp_format = 'fallback' },
        typescriptreact = { 'prettierd', timeout_ms = 500, lsp_format = 'fallback' },
        python = { 'ruff_organize_imports', 'ruff_fix', timeout_ms = 500, lsp_format = 'last' },
        json = { 'prettierd', timeout_ms = 500, lsp_format = 'never' },
        jsonc = { 'prettierd', timeout_ms = 500, lsp_format = 'never' },
        less = { 'prettierd', timeout_ms = 500, lsp_format = 'never' },
        lua = { 'stylua', timeout_ms = 500, lsp_format = 'never' },
        markdown = { 'prettierd', 'injected', timeout_ms = 1000, lsp_format = 'never' },
        css = { 'prettierd', timeout_ms = 500, lsp_format = 'never' },
        scss = { 'prettierd', timeout_ms = 500, lsp_format = 'never' },
        yaml = { 'prettierd', timeout_ms = 500, lsp_format = 'never' },
        -- For filetypes without a formatter
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
    },
    format_on_save = function()
        if not vim.g.autoformat then return nil end
        return {}
    end,
}

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function(e)
        local clients = vim.lsp.get_clients { bufnr = e.buf }
        if #clients == 0 then
            util.format_if_able(e.buf)
            return
        end
        util.preformat_ts_ls(clients, e.buf)
        util.format_if_able(e.buf)
    end,
})

--- Toggle autoformatting
vim.api.nvim_create_user_command('FmtToggle', function() vim.g.autoformat = not vim.g.autoformat end, {})

--- Manual format
vim.api.nvim_create_user_command('Fmt', function() util.format_if_able(vim.api.nvim_get_current_buf()) end, {})
