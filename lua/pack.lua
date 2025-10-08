vim.pack.add {
    { src = 'https://github.com/nvim-mini/mini.nvim' },
    { src = 'https://github.com/tpope/vim-fugitive' },
}

vim.api.nvim_create_user_command('PackClean', function()
    vim.pack.del(
        vim.iter(vim.pack.get())
            :filter(function(p) return not p.active end)
            :map(function(p) return p.spec.name end)
            :flatten()
            :totable()
    )
end, {})

vim.cmd 'packadd cfilter'
vim.cmd 'packadd nvim.undotree'
