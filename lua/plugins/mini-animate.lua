return {
    'echasnovski/mini.animate',
    event = 'VeryLazy',
    config = function()
        require('mini.animate').setup({
            scroll = {
                enable = false,
            },
        })
    end,
}
