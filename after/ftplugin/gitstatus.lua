vim.keymap.set('n', 'gf', function()
  local f = vim.fn.findfile(vim.fn.expand('<cfile>'), '**')
  vim.schedule(function() vim.cmd('vs ' .. f) end)
end, { noremap = true, buffer = true, desc = 'Open file under cursor' })
