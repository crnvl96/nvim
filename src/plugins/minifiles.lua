require('mini.files').setup({
  windows = {
    preview = true,
    width_focus = 50,
    width_nofocus = 15,
    width_preview = 80,
  },
})

local minifiles_augroup = vim.api.nvim_create_augroup('ec-mini-files', {})
vim.api.nvim_create_autocmd('User', {
  group = minifiles_augroup,
  pattern = 'MiniFilesWindowOpen',
  callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'double' }) end,
})

vim.api.nvim_create_autocmd('User', {
  group = minifiles_augroup,
  pattern = 'MiniFilesExplorerOpen',
  callback = function()
    MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
    MiniFiles.set_bookmark('m', vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim', { desc = 'mini.nvim' })
    MiniFiles.set_bookmark('p', vim.fn.stdpath('data') .. '/site/pack/deps/opt', { desc = 'Plugins' })
    MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working directory' })
  end,
})
