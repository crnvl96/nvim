return {
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = {
            preset = 'helix',
            icons = { mappings = false },
        },
        config = function(_, opts)
            local function extend_hl(name, def)
                local current_def = vim.api.nvim_get_hl(0, { name = name })
                local new_def = vim.tbl_extend('force', {}, current_def, def)

                vim.api.nvim_set_hl(0, name, new_def)
            end

            extend_hl('WhichKeyFloat', { link = 'Normal' })
            extend_hl('WhichKeyNormal', { link = 'Normal' })
            extend_hl('WhichKeySeparator', { link = 'Normal' })

            require('which-key').setup(opts)

            require('which-key').add({
                { '<leader>g', group = 'Git' },
                { '<leader>d', group = 'Debug' },
                { '<leader>f', group = 'Files' },
                { '<leader>c', group = 'Code' },
                { '<leader>x', group = 'Quickfix' },
                { '<leader>h', group = 'Git Hunks' },
                { '<leader>t', group = 'Toggle' },
            })
        end,
        keys = {
            {
                '<leader>?',
                function() require('which-key').show({ global = false }) end,
                desc = 'Buffer Local Keymaps (which-key)',
            },
        },
    },
}
