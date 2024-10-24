return {
  'echasnovski/mini.pick',
  event = 'VeryLazy',
  opts = function()
    return {
      options = {
        use_cache = true,
      },
      source = {
        show = require('mini.pick').default_show,
      },
      window = {
        config = {
          border = 'double',
        },
        prompt_cursor = '_',
        prompt_prefix = '',
      },
    }
  end,
}
