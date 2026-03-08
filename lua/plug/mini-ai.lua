require('mini.ai').setup({
  search_method = 'cover',
  custom_textobjects = {
    g = MiniExtra.gen_ai_spec.buffer(),
    f = require('mini.ai').gen_spec.treesitter({
      a = '@function.outer',
      i = '@function.inner',
    }),
    t = {
      '<([%p%w]-)%f[^<%w][^<>]->.-</%1>',
      '^<.->().*()</[^/]->$',
    },
  },
})
