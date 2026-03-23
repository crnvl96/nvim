vim.b.miniclue_config = {
  clues = {
    { mode = 'n', keys = '<leader>m', desc = '+Markdown' },
  },
}

vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', { buffer = true, desc = 'Markdown Preview' })
