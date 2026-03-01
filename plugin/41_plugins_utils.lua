Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })
  require('ts-comments').setup({ lang = { typst = { '// %s', '/* %s */' } } })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

  require('snacks').setup({
    terminal = {
      enabled = true,
    },
  })

  Config.set_keymap('n', '<Leader>gg', '<Cmd>lua Snacks.terminal("lazygit")<CR>', 'Open LazyGit')
  Config.set_keymap('n', '<Leader>ac', '<Cmd>lua Snacks.terminal("opencode")<CR>', 'Open OpenCode')
  Config.set_keymap('n', '<Leader>tt', '<Cmd>lua Snacks.terminal()<CR>', 'Open Term')
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })
  require('ts-comments').setup({ lang = { typst = { '// %s', '/* %s */' } } })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })
  require('lualine').setup()
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/tpope/vim-fugitive' })
  Config.set_keymap('n', '<Leader>gf', '<Cmd>Git<CR>', 'Open fugitive')
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/windwp/nvim-ts-autotag' })
  require('nvim-ts-autotag').setup()
end)
