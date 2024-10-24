return {
  'echasnovski/mini.icons',
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      group = group('crnvl96-mini-icons', { clear = true }),
      callback = function() require('mini.icons').mock_nvim_web_devicons() end,
    })
  end,
  opts = {},
}
