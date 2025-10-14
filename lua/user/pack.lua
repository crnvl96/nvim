vim.pack.add {
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
    { src = 'https://github.com/nvim-mini/mini.nvim' },
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/tpope/vim-fugitive' },
    { src = 'https://github.com/tpope/vim-rhubarb' },
    { src = 'https://github.com/tpope/vim-markdown' },
    { src = 'https://github.com/tpope/vim-git' },
    { src = 'https://github.com/tpope/vim-sleuth' },
    { src = 'https://github.com/tpope/vim-dispatch' },
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
