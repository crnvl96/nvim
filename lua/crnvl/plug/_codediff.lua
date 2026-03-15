vim.pack.add({ 'https://github.com/esmuellert/codediff.nvim' })

require('codediff').setup({
  diff = {
    layout = 'inline',
    compute_moves = true,
    jump_to_first_change = false,
  },
  explorer = { width = 30 },
})

vim.keymap.set(
  'n',
  '<Leader>gd',
  '<Cmd>CodeDiff<CR>',
  { desc = 'Toggle git diff' }
)
