return {
  'echasnovski/mini.icons',
  lazy = false,
  priority = 1000,
  init = function()
    local M = require('config.functions')

    -- This is lazy loaded since we not need it immediately available
    M.au('User', {
      pattern = 'VeryLazy',
      group = M.group('crnvl96-mini-icons-lazy-load', { clear = true }),
      -- For plugins that do not support `mini.icons` yet, we mock `nvim-web-devicons` here
      callback = function() require('mini.icons').mock_nvim_web_devicons() end,
    })
  end,
  opts = {},
}
