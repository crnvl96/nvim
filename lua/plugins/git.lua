return {
    {
        'NeogitOrg/neogit',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'sindrets/diffview.nvim' },
            { 'echasnovski/mini.pick' },
            {
                'echasnovski/mini.icons',
                opts = {},
                config = function(_, opts)
                    local icons = require('mini.icons')

                    icons.setup(opts)
                    icons.mock_nvim_web_devicons()
                end,
            },
        },
        opts = {
            disable_signs = true,
            graph_style = 'unicode',
            disable_line_numbers = false,
            kind = 'replace',
        },
        keys = {
            { '<Leader>gg', '<cmd>Neogit<CR>', desc = 'Neogit' },
        },
    },
}
