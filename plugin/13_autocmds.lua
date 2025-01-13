vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-on-yank', { clear = true }),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('crnvl96-resize-splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl96-auto-last-position', { clear = true }),
  callback = function(e)
    local position = vim.api.nvim_buf_get_mark(e.buf, [["]])
    local winid = vim.fn.bufwinid(e.buf)
    pcall(vim.api.nvim_win_set_cursor, winid, position)
  end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('crnvl96-auto-open-qf', { clear = true }),
  pattern = '[^lc]*',
  callback = function() vim.cmd('cwindow') end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('crnvl96-auto-open-lc', { clear = true }),
  pattern = 'l*',
  callback = function() vim.cmd('lwindow') end,
})
