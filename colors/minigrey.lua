local hues = require('mini.hues')
local colors = require('mini.colors')

local hl = vim.api.nvim_set_hl
local is_dark = vim.o.background == 'dark'

local bg = is_dark and '#212223' or '#e1e2e3'
local fg = is_dark and '#d3d4d5' or '#2d2e2f'

local palette = hues.make_palette({
  background = bg,
  foreground = fg,
  saturation = is_dark and 'lowmedium' or 'mediumhigh',
  accent = 'bg',
})

local less_palette = vim.deepcopy(palette)
less_palette.orange, less_palette.orange_bg = fg, bg
less_palette.blue, less_palette.blue_bg = fg, bg

hues.apply_palette(less_palette)

-- Generic hl groups

hl(0, 'DiagnosticInfo', { fg = less_palette.azure })
hl(0, 'DiagnosticUnderlineInfo', { sp = less_palette.azure, underline = true })
hl(0, 'DiagnosticFloatingInfo', { fg = less_palette.azure, bg = less_palette.bg_edge })
hl(0, 'MiniHipatternsTodo', { fg = less_palette.bg, bg = palette.azure, bold = true })
hl(0, 'MiniIconsBlue', { fg = less_palette.azure })
hl(0, 'MiniIconsOrange', { fg = less_palette.yellow })
hl(0, '@keyword.return', { fg = less_palette.accent, bold = true })
hl(0, 'Delimiter', { fg = less_palette.fg_edge2 })

-- Plugins related hl groups

hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

colors
  .get_colorscheme()
  :add_transparency({
    general = true,
    float = true,
    statuscolumn = true,
    statusline = true,
    tabline = true,
    winbar = true,
  })
  :apply()

vim.g.colors_name = 'minigrey'
