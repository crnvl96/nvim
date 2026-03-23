vim.b.miniclue_config = {
  clues = {
    { mode = 'n', keys = '<leader>m', desc = '+Mermaid' },
  },
}

vim.keymap.set('n', '<leader>mp', '<cmd>MermaidPreview<CR>', { buffer = true, desc = 'Mermaid Preview' })
