return {
  'tpope/vim-fugitive',
  cmd = { 'Git', 'G', 'Gvdiffsplit' },
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup(vim.g.whoami .. '/fugitive_group', {}),
      pattern = { 'fugitive', 'fugitiveblame', 'git', 'gitcommit' },
      callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
    })
  end,
}
