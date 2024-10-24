local files = require('mini.files')

files.setup({
  windows = {
    preview = true,
  },
  mappings = {
    go_in = '',
    go_in_plus = '<CR>',
    go_out = '',
    go_out_plus = '-',
  },
})

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('crnvl96/mini_files', {}),
  pattern = 'MiniFilesWindowOpen',
  callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'double' }) end,
})

vim.keymap.set('n', '-', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', { desc = 'File explorer' })
