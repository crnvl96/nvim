require('mini.visits').setup()
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

require('mini.pick').setup({
    options = {
        use_cache = true,
    },
    window = {
        config = {
            border = 'double',
        },
        prompt_cursor = '_',
        prompt_prefix = '',
    },
})

vim.ui.select = require('mini.pick').ui_select

vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<CR>', { desc = 'Pick files' })
vim.keymap.set('n', '<leader>fk', '<cmd>Pick keymaps<CR>', { desc = 'Pick keymaps' })
vim.keymap.set('n', '<leader>fl', "<cmd>Pick buf_lines scope='current'<CR>", { desc = 'Pick buflines' })
vim.keymap.set('n', '<leader>fo', '<cmd>Pick visit_paths<CR>', { desc = 'Pick visit paths' })
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<CR>', { desc = 'Pick grep' })
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<CR>', { desc = 'Pick help' })
vim.keymap.set('n', '<leader>fr', '<cmd>Pick resume<CR>', { desc = 'Pick resume' })
vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<CR>', { desc = 'Pick buffers' })
vim.keymap.set('n', '<C-b>', '<cmd>Pick buffers<CR>', { desc = 'Pick buffers' })
vim.keymap.set('n', '-', '<cmd>lua MiniFiles.open()<CR>')

vim.api.nvim_create_autocmd('User', {
    group = vim.api.nvim_create_augroup('crnvl96_mini_files', {}),
    pattern = 'MiniFilesWindowOpen',
    callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'double' }) end,
})
