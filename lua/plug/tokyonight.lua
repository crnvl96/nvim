vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
})

require('tokyonight').setup()

local variants = {
  'tokyonight-night',
  'tokyonight-storm',
  'tokyonight-day',
  'tokyonight-moon',
}

vim.cmd.colorscheme(variants[1])
