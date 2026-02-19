Config.later(function() vim.pack.add({ 'https://github.com/tpope/vim-fugitive' }) end)

Config.later(function()
  vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })
  require('lualine').setup()
end)
