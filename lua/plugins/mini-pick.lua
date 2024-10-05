local minipick = require('mini.pick')
minipick.setup({
    options = {
        use_cache = true,
    },
    window = {
        prompt_cursor = '_',
        prompt_prefix = '',
        config = {
            border = 'rounded',
            height = math.floor(0.618 * vim.o.lines),
            width = math.floor(0.850 * vim.o.columns),
        },
    },
})

vim.ui.select = minipick.ui_select

vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<CR>', { desc = 'Pick files' })
vim.keymap.set('n', '<leader>fk', '<cmd>Pick keymaps<CR>', { desc = 'Pick keymaps' })
vim.keymap.set('n', '<leader>fl', '<cmd>Pick buf_lines<CR>', { desc = 'Pick buflines' })
vim.keymap.set('n', '<leader>fv', '<cmd>Pick visit_paths<CR>', { desc = 'Pick visit paths' })
vim.keymap.set('n', '<leader>fm', '<cmd>Pick visit_labels<CR>', { desc = 'Pick labels' })
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<CR>', { desc = 'Pick grep' })
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<CR>', { desc = 'Pick help' })
vim.keymap.set('n', '<leader>fr', '<cmd>Pick resume<CR>', { desc = 'Pick resume' })
vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<CR>', { desc = 'Pick buffers' })
