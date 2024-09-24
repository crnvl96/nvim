return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
        vim.api.nvim_set_hl(
            0,
            'WhichKeySeparator',
            vim.tbl_extend(
                'force',
                {},
                vim.api.nvim_get_hl(0, { name = 'WhichKeySeparator' }),
                { bg = vim.g.palette.base00 }
            )
        )

        require('which-key').setup({
            delay = 100,
            preset = 'helix',
            icons = {
                group = ' +',
            },
        })

        require('which-key').add({
            { '<Leader>c', group = 'Code' },
            { '<Leader>d', group = 'Debug' },
            { '<Leader>f', group = 'Files' },
            { '<Leader>h', group = 'Git Hunks' },
            { '<Leader>x', group = 'Quickfix' },
            { '<Leader>t', group = 'Terminal' },
        })
    end,
}
