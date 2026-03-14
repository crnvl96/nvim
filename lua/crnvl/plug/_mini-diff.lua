require('mini.diff').setup({
  view = { style = 'sign' },
})

vim.keymap.set(
  'n',
  '<Leader>go',
  function() MiniDiff.toggle_overlay() end,
  { desc = 'Toggle git overlay' }
)

vim.keymap.set('n', '<Leader>ge', function()
  vim.fn.setqflist(MiniDiff.export('qf'))
  vim.cmd('copen')
end, { desc = 'Export to Quickfix' })
