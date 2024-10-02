return {
    'echasnovski/mini.indentscope',
    event = 'VeryLazy',
    config = function()
        require('mini.indentscope').setup({
            options = {
                try_as_border = true,
            },
            symbol = '╎',
        })
    end,
}
