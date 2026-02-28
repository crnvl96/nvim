Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })
  require('ts-comments').setup({ lang = { typst = { '// %s', '/* %s */' } } })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })
  require('lualine').setup()
end)

Config.now_if_args(function() vim.pack.add({ 'https://github.com/tpope/vim-fugitive' }) end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/windwp/nvim-ts-autotag' })
  require('nvim-ts-autotag').setup()
end)
