vim.cmd('setlocal colorcolumn=89')

vim.g.pyindent_open_paren = 'shiftwidth()'
vim.g.pyindent_continue = 'shiftwidth()'

vim.b.miniindentscope_config = { options = { border = 'top' } }

local has_dap = pcall(require, 'dap')

-- stylua: ignore
if has_dap then
  vim.keymap.set('n', '<leader>dpc', function() require('dap-python').test_class() end, { desc = '(python) dap: debug class' })
  vim.keymap.set('n', '<leader>dpt', function() require('dap-python').test_method() end, { desc = '(python) dap: debug method' })
end
