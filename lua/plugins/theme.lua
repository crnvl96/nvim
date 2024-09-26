return {
    {
        'echasnovski/mini.base16',
        lazy = false,
        priority = 1000,
        config = function()
            require('mini.base16').setup({
                palette = vim.g.palette,
            })
        end,
    },
    {
        'echasnovski/mini.icons',
        lazy = false,
        config = function()
            require('mini.icons').setup()
            require('mini.icons').mock_nvim_web_devicons()
        end,
    },
}
