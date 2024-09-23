return {
    {
        'echasnovski/mini.ai',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
        opts = function()
            return {
                n_lines = 300,
                custom_textobjects = {
                    f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
                },
                silent = true,
                search_method = 'cover',
                mappings = {
                    around_next = '',
                    inside_next = '',
                    around_last = '',
                    inside_last = '',
                },
            }
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = { 'BufReadPre', 'BufNewFile' },
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
            indent = {
                enable = true,
                disable = function(_, buf)
                    if not vim.bo[buf].modifiable then return false end

                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))

                    if not ok or not stats or stats.size > vim.g.bigfile_size then
                        vim.wo[0][0].foldmethod = 'indent'

                        return true
                    end

                    vim.api.nvim_buf_call(buf, function()
                        vim.wo[0][0].foldmethod = 'expr'
                        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                        vim.cmd.normal('zx')
                    end)

                    return false
                end,
            },
            incremental_selection = { enable = false },
        },
        config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
    },
}
