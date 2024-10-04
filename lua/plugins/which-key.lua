return {
    {
        'folke/which-key.nvim',
        event = { 'VeryLazy', 'BufReadPre', 'BufNewFile' },
        opts = {
            delay = 200,
            preset = 'helix',
            icons = {
                mappings = false,
            },
        },
        config = function(_, opts)
            local wk = require('which-key')
            wk.setup(opts)
            wk.add({
                { '<leader>c', group = 'Code' },
                { '<leader>d', group = 'Debug' },
                { '<leader>m', group = 'Search' },
                { '<leader>f', group = 'File' },
                { '<leader>g', group = 'Git' },
                { '<leader>h', group = 'Git hunks' },
                { '<leader>t', group = 'Toggle' },
                { '<leader>x', group = 'Quickfix' },
                { '<leader>v', group = 'Visits' },
            })
        end,
    },
}
