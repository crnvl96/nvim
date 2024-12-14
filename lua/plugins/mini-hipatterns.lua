return {
  'echasnovski/mini.hipatterns',
  event = 'VeryLazy',
  opts = function()
    return {
      highlighters = {
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      },
    }
  end,
}
