return {
  'echasnovski/mini.diff',
  event = 'VeryLazy',
  opts = {
    view = { style = 'sign' },
  },
  keys = {
    { '<leader>go', function() require('mini.diff').toggle_overlay(0) end, desc = 'minidiff: overlay' },
  },
}
