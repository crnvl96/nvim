au('TextYankPost', {
  group = group('crnvl96-highlight-on-yank', { clear = true }),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})
