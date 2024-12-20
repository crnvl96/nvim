local themes = {
  cyan = { background = '#002923', foreground = '#c0c9c7' },
  azure = { background = '#002734', foreground = '#c0c8cc' },
}

require('mini.hues').setup(themes.cyan)

vim.g.colors_name = 'minicolors'
