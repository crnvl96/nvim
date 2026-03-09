vim.pack.add({
  'https://github.com/HakonHarnes/img-clip.nvim',
})

require('img-clip').setup({
  default = {
    dir_path = 'static/img',
  },
})
