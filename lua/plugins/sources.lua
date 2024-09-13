local add = require('mini.deps').add

add('nvim-lua/plenary.nvim')
add('nvim-neotest/nvim-nio')

add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = {
        post_update = function() vim.cmd('TSUpdate') end,
    },
})

add('theHamsta/nvim-dap-virtual-text')
add('leoluz/nvim-dap-go')
add('rcarriga/nvim-dap-ui')
add('mfussenegger/nvim-dap')

add('stevearc/conform.nvim')

add('hrsh7th/cmp-buffer')
add('hrsh7th/cmp-path')
add('hrsh7th/cmp-nvim-lua')
add('hrsh7th/cmp-nvim-lsp')
add('hrsh7th/nvim-cmp')

add({
    source = 'williamboman/mason.nvim',
    hooks = {
        post_checkout = function() vim.cmd('MasonUpdate') end,
    },
})
add('WhoIsSethDaniel/mason-tool-installer.nvim')
add('williamboman/mason-lspconfig.nvim')
add('neovim/nvim-lspconfig')

add('tpope/vim-fugitive')
add('tpope/vim-rhubarb')
add('stevearc/oil.nvim')
add('ibhagwan/fzf-lua')
