vim.keymap.set('n', '<CR>', function()
  vim.cmd('silent write')
  vim.cmd('exe "!' .. vim.fn.shellescape(vim.o.shell) .. ' %"')
  if vim.v.shell_error == 0 then
    vim.cmd.close()
  end
end, { buffer = true, silent = true })
