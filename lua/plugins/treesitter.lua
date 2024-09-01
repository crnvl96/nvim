MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_update = function() vim.cmd('TSUpdate') end },
})

local tools = require('tools')

local treesitter = require('nvim-treesitter.configs')

treesitter.setup({
    ensure_installed = tools.ts_parsers,
    sync_install = false,
    auto_install = true,
    indent = { enable = true },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'markdown' },
    },
})
