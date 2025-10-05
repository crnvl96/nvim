require('mini.files').setup {
    content = { prefix = function() end },
    mappings = {
        close = 'q',
        go_in = '',
        go_in_plus = '<CR>',
        go_out = '',
        go_out_plus = '-',
        mark_goto = "'",
        mark_set = 'm',
        reset = '<BS>',
        reveal_cwd = '@',
        show_help = 'g?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
    },
}

vim.keymap.set('n', '-', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
