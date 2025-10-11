local util = require 'util.formatter'
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.autoformat = true

require('conform').setup {
    notify_on_error = false,
    notify_no_formatters = false,
    default_format_opts = {
        lsp_format = 'fallback',
        timeout_ms = 500,
    },
    formatters = {
        stylua = { require_cwd = true },
        prettier = {
            require_cwd = true,
            ft_parsers = {
                javascript = 'babel',
                javascriptreact = 'babel',
                typescript = 'typescript',
                typescriptreact = 'typescript',
                vue = 'vue',
                css = 'css',
                scss = 'scss',
                less = 'less',
                html = 'html',
                json = 'json',
                jsonc = 'json',
                yaml = 'yaml',
                markdown = 'markdown',
                ['markdown.mdx'] = 'mdx',
                graphql = 'graphql',
                handlebars = 'glimmer',
            },
            ext_parsers = {
                qmd = 'markdown',
            },
        },
        injected = {
            ignore_errors = true,
            lang_to_ft = {
                bash = 'sh',
                javascript = 'js',
                markdown = 'md',
                python = 'py',
                typescript = 'ts',
                go = 'go',
            },
            lang_to_ext = {
                bash = 'sh',
                markdown = 'md',
                python = 'py',
                javascript = 'js',
                typescript = 'ts',
                go = 'go',
            },
            lang_to_formatters = {},
        },
    },
    formatters_by_ft = {
        go = { 'gofumpt' },
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        python = { 'ruff', 'ruff_organize_imports', 'ruff_fix' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        less = { 'prettierd' },
        lua = { 'stylua' },
        markdown = { 'prettierd', 'injected', timeout_ms = 1000 },
        css = { 'prettierd' },
        scss = { 'prettierd' },
        yaml = { 'prettierd' },
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
