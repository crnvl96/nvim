require('mini.visits').setup()

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

-- Mini.Pick
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<CR>', { desc = 'Pick files' })
vim.keymap.set('n', '<leader>fk', '<cmd>Pick keymaps<CR>', { desc = 'Pick keymaps' })
vim.keymap.set('n', '<leader>fl', "<cmd>Pick buf_lines scope='current'<CR>", { desc = 'Pick buflines' })
vim.keymap.set('n', '<leader>fo', '<cmd>Pick visit_paths<CR>', { desc = 'Pick visit paths' })
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<CR>', { desc = 'Pick grep' })
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<CR>', { desc = 'Pick help' })
vim.keymap.set('n', '<leader>fr', '<cmd>Pick resume<CR>', { desc = 'Pick resume' })
vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<CR>', { desc = 'Pick buffers' })
vim.keymap.set('n', '<C-b>', '<cmd>Pick buffers<CR>', { desc = 'Pick buffers' })
