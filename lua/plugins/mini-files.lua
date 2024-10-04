return {
    {
        'echasnovski/mini.files',
        init = function()
            vim.api.nvim_create_autocmd('User', {
                group = vim.api.nvim_create_augroup(vim.g.whoami .. '/mini_files_setup', { clear = true }),
                pattern = 'MiniFilesWindowOpen',
                callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'rounded' }) end,
            })
        end,
        opts = {
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
            options = {
                permanent_delete = false,
            },
            windows = {
                preview = true,
                width_preview = 120,
            },
        },
        keys = {
            { '-', '<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', desc = 'Explorer (Mini.files)' },
        },
    },
}
