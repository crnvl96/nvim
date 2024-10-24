return {
  {
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
  },
  {
    'zenbones-theme/zenbones.nvim',
    dependencies = 'rktjmp/lush.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.zenbones_darken_comments = 45
      vim.cmd.colorscheme('tokyobones')
    end,
  },
}
