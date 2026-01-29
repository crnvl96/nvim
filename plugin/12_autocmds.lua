---@diagnostic disable: undefined-global

local now = MiniDeps.now

now(function()
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('crnvl96-highlight-on-yank', {}),
    callback = function() vim.highlight.on_yank() end,
  })

  vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = vim.api.nvim_create_augroup('crnvl96-auto-open-qf', { clear = true }),
    pattern = { '[^l]*' },
    command = 'cwindow',
  })
end)
