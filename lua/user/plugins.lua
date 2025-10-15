vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.autoformat = true

-- stylua: ignore
local ensure_installed = {
    'html', 'css',        'go',       'python',
    'diff', 'bash',       'json',     'regex',
    'toml', 'yaml',       'markdown', 'javascript',
    'jsx',  'typescript', 'tsx',
}

local to_install = vim.tbl_filter(function(lang)
    local has_parser = vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false)
    return #has_parser == 0
end, ensure_installed)

if #to_install > 0 then require('nvim-treesitter').install(to_install) end

require('conform').setup {
    notify_on_error = false,
    notify_no_formatters = false,
    default_format_opts = {
        lsp_format = 'fallback',
        timeout_ms = 1000,
    },
    formatters = {
        stylua = { require_cwd = true },
        prettier = { require_cwd = true },
        injected = { ignore_errors = true },
    },
    formatters_by_ft = {
        go = { 'gofumpt' },
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        python = { 'ruff_organize_imports', 'ruff_fix', 'ruff' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        less = { 'prettierd' },
        lua = { 'stylua' },
        markdown = { 'prettierd', 'injected', timeout_ms = 1500 },
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

vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable(),
    callback = function(e)
        local buf = e.buf
        local win = vim.api.nvim_get_current_win()
        vim.wo[win].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.treesitter.start(e.buf)
    end,
})

vim.api.nvim_create_user_command('FmtToggle', function()
    local t = vim.g.autoformat
    vim.g.autoformat = not t
end, {})

vim.api.nvim_create_user_command('Fmt', function()
    local buf = vim.api.nvim_get_current_buf()
    require('conform').format { bufnr = buf }
end, {})
