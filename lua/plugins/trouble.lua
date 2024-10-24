return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {},
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buf diagnostics' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics' },
    { '<leader>cs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols' },
  },
}
