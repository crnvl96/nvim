return {
    {
        'MagicDuck/grug-far.nvim',
        cmd = 'GrugFar',
        config = function()
            require('grug-far').setup()

            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup(vim.g.whoami .. '/grug_group', {}),
                pattern = { 'grug-far' },
                callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
            })
        end,
        keys = {
            {
                '<leader>cr',
                function()
                    local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
                    require('grug-far').open({
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
                            keymaps = { help = '?' },
                        },
                    })
                end,
                mode = { 'n', 'v' },
                desc = 'Search and Replace',
            },
            {
                '<leader>c%',
                function()
                    local cur = vim.bo.buftype == '' and vim.fn.expand('%')
                    require('grug-far').open({
                        transient = true,
                        prefills = {
                            filesFilter = cur ~= '' and cur or nil,
                            keymaps = { help = '?' },
                        },
                    })
                end,
                mode = { 'n', 'v' },
                desc = 'Search in local buffer',
            },
        },
    },
    {

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
                delay = 200,
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
                {
                    '<Leader>b',
                    group = 'Buffers',
                    expand = function() return require('which-key.extras').expand.buf() end,
                },
            })
        end,
    },
}
