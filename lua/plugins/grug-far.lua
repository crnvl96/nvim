return {
    {
        'MagicDuck/grug-far.nvim',
        cmd = 'GrugFar',
        opts = {},
        config = function(_, opts)
            require('grug-far').setup(opts)

            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup(vim.g.whoami .. '/grugfar_group', {}),
                pattern = { 'grug-far' },
                callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
            })
        end,
        keys = {
            { '<leader>c', '', desc = 'Code' },
            {
                '<leader>cr',
                function()
                    require('grug-far').open({
                        transient = true,
                        keymaps = { help = '?' },
                    })
                end,
                desc = 'Search and replace',
                mode = { 'n', 'v' },
            },
        },
    },
}
