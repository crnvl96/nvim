return {
    {
        'nvim-treesitter/nvim-treesitter',

        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter-context',
                opts = {
                    max_lines = 3,
                    multiline_threshold = 1,
                    min_window_height = 20,
                },
                keys = {
                    {
                        '[[',
                        function()
                            vim.schedule(function() require('treesitter-context').go_to_context() end)
                            return '<Ignore>'
                        end,
                        desc = 'Jump to upper context',
                        expr = true,
                    },
                },
            },
        },
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'c',
                    'vim',
                    'vimdoc',
                    'query',
                    'markdown',
                    'markdown_inline',
                    'javascript',
                    'typescript',
                    'lua',
                },
                highlight = {
                    enable = true,
                    disable = function(_, buf)
                        if not vim.bo[buf].modifiable then return false end
                        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                        return ok and stats and stats.size > vim.g.bigfile_size
                    end,
                },
                indent = {
                    enable = true,
                },
                incremental_selection = {
                    enable = false,
                },
            })
        end,
    },
}
