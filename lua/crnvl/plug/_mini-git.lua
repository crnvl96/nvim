require('mini.git').setup()

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniGitCommandSplit',
  group = Config.gr,
  callback = function(e)
    if e.data.git_subcommand ~= 'status' then return end
    vim.api.nvim_set_option_value(
      'filetype',
      'gitstatus',
      { scope = 'local', buf = vim.api.nvim_win_get_buf(e.data.win_stdout) }
    )
  end,
})

vim.keymap.set(
  'n',
  '<Leader>gs',
  '<Cmd>Git status<CR>',
  { desc = 'Git status' }
)

vim.keymap.set(
  'n',
  '<Leader>gc',
  '<Cmd>Git commit<CR>',
  { desc = 'Git commit' }
)
