return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = 'VeryLazy',
        build = ':TSUpdate',
        lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treesitter** module to be loaded in time.
            -- Luckily, the only things that those plugins need are the custom queries, which we make available
            -- during startup.
            require('lazy.core.loader').add_to_rtp(plugin)
            require('nvim-treesitter.query_predicates')
        end,
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
        opts = {
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
        },
        config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
    },
}
