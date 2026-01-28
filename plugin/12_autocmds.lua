---@diagnostic disable: undefined-global

local now = MiniDeps.now

now(function()
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('crnvl96-highlight-on-yank', {}),
    callback = function() vim.highlight.on_yank() end,
  })
end)
