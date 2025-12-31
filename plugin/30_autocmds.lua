vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-after-yank', {}),
  callback = function() vim.highlight.on_yank() end,
})
