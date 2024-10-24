return {
  dir = '~/Developer/personal_projects/lazydocker.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  config = function() require('lazydocker').setup({ height = 0.5 }) end,
  keys = {
    { '<leader>cw', function() print('done!') end, desc = 'Lazydocker' },
  },
}
