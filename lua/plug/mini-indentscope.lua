require('mini.indentscope').setup({
  options = {
    try_as_border = true,
  },
})

vim.api.nvim_create_autocmd('FileType', {
  group = Config.gr,
  pattern = { 'terminal' },
  callback = function(e) vim.b[e.buf].miniindentscope_disable = true end,
})
