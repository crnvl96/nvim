return {
    'echasnovski/mini.diff',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('mini.diff').setup({
            view = { style = 'sign' },
            mappings = {
                apply = 'gh',
                reset = 'gH',
                textobject = 'gh',
                goto_first = '[H',
                goto_prev = '[h',
                goto_next = ']h',
                goto_last = ']H',
            },
        })
    end,
}
