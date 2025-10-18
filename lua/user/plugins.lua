vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.autoformat = true

-- stylua: ignore
local ensure_installed = {
    'html',       'css',  'go',       'python',
    'diff',       'bash', 'json',     'regex',
    'toml',       'yaml', 'markdown', 'javascript',
    'typescript', 'tsx'
}

require('nvim-treesitter').install(
    vim.iter(ensure_installed)
        :filter(function(i) return #vim.api.nvim_get_runtime_file('parser/' .. i .. '.*', false) == 0 end)
        :totable()
)

require('quicker').setup {
    keys = {
        {
            '>',
            function() require('quicker').expand { before = 2, after = 2, add_to_existing = true } end,
            desc = 'Expand quickfix context',
        },
        {
            '<',
            function() require('quicker').collapse() end,
            desc = 'Collapse quickfix context',
        },
    },
}

vim.keymap.set('n', '<leader>x', function() require('quicker').toggle() end, {
    desc = 'Toggle quickfix',
})

vim.keymap.set('n', '<leader>X', function() require('quicker').toggle { loclist = true } end, {
    desc = 'Toggle loclist',
})

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
        python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
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

vim.keymap.set('n', [[\f]], function()
    local t = vim.g.autoformat
    vim.g.autoformat = not t
end, { desc = "Toggle 'vim.g.autoformat'" })
