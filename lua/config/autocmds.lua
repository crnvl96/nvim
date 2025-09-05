vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('crnvl-post-grep-events', { clear = true }),
  pattern = '*grep*',
  command = 'cwindow',
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = vim.api.nvim_create_augroup('crnvl-checktime', { clear = true }),
  callback = function()
    if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl-highlight-on-yank', { clear = true }),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('crnvl-termoptions', { clear = true }),
  command = 'setlocal listchars= nonumber norelativenumber',
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl-last-location', { clear = true }),
  callback = function(e)
    local mark = vim.api.nvim_buf_get_mark(e.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(e.buf)
    if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('crnvl-resize', { clear = true }),
  command = 'tabdo wincmd =',
})
