Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

  require('snacks').setup()

  vim.keymap.set('n', '<Leader>gg', function() Snacks.lazygit() end, { desc = 'Open LazyGit' })
end)
