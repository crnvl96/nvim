return {
  'echasnovski/mini.icons',
  -- Don't lazy load this plugin since a lot of other plugind depend on it
  lazy = false,
  init = function()
    -- On the other hand, this is lazy loaded since we not need it immediately available
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      group = group('crnvl96-mini-icons-lazy-load', { clear = true }),
      -- For plugins that do not support `mini.icons` yet, we mock `nvim-web-devicons` here
      callback = function() require('mini.icons').mock_nvim_web_devicons() end,
    })
  end,
  opts = {},
}
