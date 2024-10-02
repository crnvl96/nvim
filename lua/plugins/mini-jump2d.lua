return {
    'echasnovski/mini.jump2d',
    event = 'VeryLazy',
    config = function()
        require('mini.jump2d').setup({
            view = {
                dim = true,
                n_steps_ahead = 1,
            },
        })
    end,
}
