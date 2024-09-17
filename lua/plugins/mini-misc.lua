return {
    {
        'echasnovski/mini.misc',
        event = 'BufEnter',
        config = function()
            require('mini.misc').setup_restore_cursor({
                center = true,
            })
        end,
    },
}
