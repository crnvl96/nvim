local M = require('config.functions')


-- Briefly highlight the yanked text
-- Just a small visual feedback
M.au('TextYankPost', {
  group = M.group('crnvl96-highlight-on-yank', { clear = true }),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})
