return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
        require('which-key').setup({
            delay = 200,
            preset = 'helix',
            icons = {
                group = '+',
            },
        })

        require('which-key').add({
            { '<leader>c', group = 'code' },
            { '<leader>d', group = 'debug' },
            { '<leader>f', group = 'file' },
            { '<leader>g', group = 'git' },
        })
    end,
}
