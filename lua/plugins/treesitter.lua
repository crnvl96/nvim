return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPre', 'BufNewFile' },
        build = ':TSUpdate',
        lazy = vim.fn.argc(-1) == 0,
        init = function(plugin)
            require('lazy.core.loader').add_to_rtp(plugin)
            require('nvim-treesitter.query_predicates')
        end,
        opts = {
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
                disable = function(_, buf)
                    if not vim.bo[buf].modifiable then return false end
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    return ok and stats and stats.size > vim.g.bigfile_size
                end,
            },
            indent = { enable = true },
            incremental_selection = { enable = false },
        },
        config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
    },
}
