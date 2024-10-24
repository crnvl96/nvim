return {
  dir = '~/Developer/lazydocker.nvim',
  lazy = false,
  dependencies = { 'MunifTanjim/nui.nvim' },
  config = function() require('lazydocker').setup({ height = 10 }) end,
}
