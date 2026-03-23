vim.b.miniclue_config = {
  clues = {
    { mode = 'n', keys = '<leader>m', desc = '+Typst' },
  },
}

vim.keymap.set('n', '<leader>mp', '<cmd>TypstPreview<CR>', { buffer = true, desc = 'Typst Preview' })
