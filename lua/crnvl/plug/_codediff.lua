vim.pack.add({ 'https://github.com/esmuellert/codediff.nvim' })

require('codediff').setup()

vim.keymap.set(
  'n',
  '<Leader>gd',
  '<Cmd>CodeDiff<CR>',
  { desc = 'Toggle git diff' }
)
