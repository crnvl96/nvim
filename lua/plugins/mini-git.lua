return {
  'echasnovski/mini-git',
  main = 'mini.git',
  cmd = 'Git',
  opts = {},
  keys = {
    {
      '<leader>gi',
      function() require('mini.git').show_at_cursor() end,
      desc = 'minigit: show at cursor',
      mode = { 'n', 'x' },
    },
  },
}
