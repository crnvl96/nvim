vim.pack.add({ 'https://github.com/esmuellert/codediff.nvim' })

require('codediff').setup({
  diff = {
    layout = 'inline',
  },
})
