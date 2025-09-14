vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = '*grep*', command = 'cwindow' })
vim.api.nvim_create_autocmd('TextYankPost', { callback = function() (vim.hl or vim.highlight).on_yank() end })
vim.api.nvim_create_autocmd('TermOpen', { command = 'setlocal listchars= nonumber norelativenumber' })
vim.api.nvim_create_autocmd('VimResized', { command = 'tabdo wincmd =' })

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  callback = function()
    if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(e)
    local mark = vim.api.nvim_buf_get_mark(e.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(e.buf)
    if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
  end,
})
