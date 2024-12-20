require('mini.pick').setup({
  options = {
    use_cache = true,
  },
  window = {
    config = {
      border = 'double',
    },
    prompt_cursor = '_',
    prompt_prefix = '',
  },
})

vim.ui.select = MiniPick.ui_select
