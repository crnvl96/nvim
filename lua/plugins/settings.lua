MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

require('mini.extra').setup()
require('mini.misc').setup_restore_cursor()
require('mini.misc').setup_termbg_sync()
require('mini.misc').setup_auto_root()

require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'c',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
        'lua',
        'javascript',
        'typescript',
        'python',
        'ninja',
        'rst',
    },
    highlight = {
        enable = true,
        disable = function(_, bufnr)
            if not vim.bo[bufnr].modifiable then return false end
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
            return ok and stats and stats.size > 1024 * 250
        end,
    },
    indent = { enable = true },
    incremental_selection = { enable = false },
})
