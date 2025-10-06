vim.g.autoformat = true
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup {
    notify_on_error = true,
    format_on_save = function()
        if not vim.g.autoformat then return nil end
        return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
    formatters = {
        prettier = { require_cwd = false },
    },
    formatters_by_ft = {
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        yaml = { 'prettier' },
        lua = { 'stylua' },
        markdown = { 'prettier' },
        python = { lsp_format = 'prefer', name = 'ruff' },
        go = { lsp_format = 'prefer' },
    },
}

vim.api.nvim_create_user_command(
    'Fmt',
    function() require('conform').format { bufnr = vim.api.nvim_get_current_buf() } end,
    { nargs = 0 }
)

vim.api.nvim_create_user_command('ToggleFmt', function()
    vim.g.autoformat = not vim.g.autoformat
    local suffix = vim.g.autoformat and 'Enabling' or 'Disabling'
    vim.notify(('%s formatting...'):format(suffix), vim.log.levels.INFO)
end, { nargs = 0 })
