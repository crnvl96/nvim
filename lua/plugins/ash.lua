MiniDeps.now(function()
  MiniDeps.add 'vague2k/vague.nvim'

  require('vague').setup { transparent = true }

  vim.cmd.colorscheme 'vague'
end)
