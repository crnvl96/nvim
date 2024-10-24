vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-on-yank', { clear = true }),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})
