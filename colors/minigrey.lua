local is_dark = vim.o.background == 'dark'
local bg = is_dark and '#212223' or '#e1e2e3'
local fg = is_dark and '#d3d4d5' or '#2d2e2f'

local hues = require('mini.hues')
local p = hues.make_palette({
  background = bg,
  foreground = fg,
  saturation = is_dark and 'lowmedium' or 'mediumhigh',
  accent = 'bg',
})

local less_p = vim.deepcopy(p)
less_p.orange, less_p.orange_bg = fg, bg
less_p.blue, less_p.blue_bg = fg, bg

hues.apply_palette(less_p)
vim.g.colors_name = 'minigrey'

local hi = function(group, data) vim.api.nvim_set_hl(0, group, data) end

hi('DiagnosticInfo', { fg = less_p.azure })
hi('DiagnosticUnderlineInfo', { sp = less_p.azure, underline = true })
hi('DiagnosticFloatingInfo', { fg = less_p.azure, bg = less_p.bg_edge })

hi('MiniHipatternsTodo', { fg = less_p.bg, bg = p.azure, bold = true })
hi('MiniIconsBlue', { fg = less_p.azure })
hi('MiniIconsOrange', { fg = less_p.yellow })

hi('@keyword.return', { fg = less_p.accent, bold = true })
hi('Delimiter', { fg = less_p.fg_edge2 })
