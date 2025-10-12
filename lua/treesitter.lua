local ensure_installed = {
    'html',
    'css',

    'go',
    'python',

    'diff',
    'bash',
    'json',
    'regex',
    'toml',
    'yaml',
    'markdown',

    'javascript',
    'jsx',
    'typescript',
    'tsx',
}

local to_install = vim.tbl_filter(function(lang)
    local has_parser = vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false)
    return #has_parser == 0
end, ensure_installed)

if #to_install > 0 then require('nvim-treesitter').install(to_install) end

vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable(),
    callback = function(e)
        vim.treesitter.start(e.buf)
        vim.wo[vim.api.nvim_get_current_win()].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo[e.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
