require('mini.diff').setup({
    view = {
        -- style = vim.go.number and 'number' or 'sign',
        style = 'sign',
    },
})

vim.keymap.set('n', '<leader>go', '<cmd>lua MiniDiff.toggle_overlay()<CR>', { desc = 'Git overlay' })
