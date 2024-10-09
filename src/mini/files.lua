require('mini.files').setup({
    windows = {
        preview = true,
        width_preview = 80,
    },
    mappings = {
        close = 'q',
        go_in = '',
        go_in_plus = '<CR>',
        go_out = '',
        go_out_plus = '-',
        mark_goto = "'",
        mark_set = 'm',
        reset = '<BS>',
        reveal_cwd = '_',
        show_help = 'g?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
    },
})

vim.api.nvim_create_autocmd('User', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/mini_files', {}),
    pattern = 'MiniFilesWindowOpen',
    callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'double' }) end,
})

vim.keymap.set('n', '-', '<cmd>lua MiniFiles.open()<CR>')
