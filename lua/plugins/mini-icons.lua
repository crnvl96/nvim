return {
  'echasnovski/mini.icons',
  lazy = false,
  priority = 1000,
  init = function()
    Au('User', {
      pattern = 'VeryLazy',
      group = Group('mini-icons-lazy-load'),
      callback = function() require('mini.icons').mock_nvim_web_devicons() end,
    })
  end,
  opts = {},
}
