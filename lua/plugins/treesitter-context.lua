return {
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
}
