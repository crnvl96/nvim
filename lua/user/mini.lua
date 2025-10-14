require('mini.extra').setup {}
require('mini.misc').setup {}
require('mini.align').setup {}
require('mini.splitjoin').setup {}

MiniMisc.setup_restore_cursor()
MiniMisc.setup_auto_root()

require('mini.bracketed').setup()

vim.keymap.set('n', '-', '<Cmd>20 Lex<CR>')

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
