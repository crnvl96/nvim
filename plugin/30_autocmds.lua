Config.now(function()
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = Config.gr,
    command = 'lua vim.highlight.on_yank()',
  })

  vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = Config.gr,
    pattern = '[^l]*',
    command = 'cwindow',
  })
end)
