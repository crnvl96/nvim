return {
    'folke/which-key.nvim',
    event = { 'VeryLazy', 'BufReadPre', 'BufNewFile' },
    config = function()
        require('which-key').setup({
            delay = 200,
            preset = 'helix',
            icons = {
                group = ' +',
            },
        })

        require('which-key').add({
            { '<leader>c', group = 'Code' },
            { '<leader>d', group = 'Debug' },
            { '<leader>f', group = 'File' },
            { '<leader>g', group = 'Git' },
            { '<leader>h', group = 'Git hunks' },
            { '<leader>t', group = 'Toggle' },
            { '<leader>x', group = 'Quickfix' },
        })
    end,
}
