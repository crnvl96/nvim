return {
    {
        'echasnovski/mini.icons',
        config = function()
            require('mini.icons').setup()
            require('mini.icons').mock_nvim_web_devicons()
        end,
    },
    {

        'echasnovski/mini.base16',
        lazy = false,
        priority = 1000,
        opts = {
            palette = {
                base00 = '#181818',
                base01 = '#282828',
                base02 = '#383838',
                base03 = '#585858',
                base04 = '#b8b8b8',
                base05 = '#d8d8d8',
                base06 = '#e8e8e8',
                base07 = '#f8f8f8',
                base08 = '#ab4642',
                base09 = '#dc9656',
                base0A = '#f7ca88',
                base0B = '#a1b56c',
                base0C = '#86c1b9',
                base0D = '#7cafc2',
                base0E = '#ba8baf',
                base0F = '#a16946',
            },
        },
        config = function(_, opts)
            vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
            vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })

            require('mini.base16').setup(opts)
        end,
    },
}
