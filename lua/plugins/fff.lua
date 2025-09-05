require('fff').setup({
  prompt = '🪿 ',
  title = 'FFFiles',
  layout = {
    height = 0.4,
    width = 0.4,
  },
  preview = { enabled = false },
})

vim.keymap.set('n', '<Leader>f', require('fff').find_files)
