local util = require 'util.ui'

vim.opt.fillchars = {
    foldopen = '',
    foldclose = '',
    fold = ' ',
    foldsep = ' ',
    diff = '╱',
    eob = ' ',
    horiz = '═',
    horizdown = '╦',
    horizup = '╩',
    vert = '║',
    verthoriz = '╬',
    vertleft = '╣',
    vertright = '╠',
}

vim.opt.listchars = {
    extends = '…',
    nbsp = '␣',
    precedes = '…',
    tab = '  ',
    trail = '·',
}

vim.api.nvim_create_autocmd('TextYankPost', { callback = function() (vim.hl or vim.highlight).on_yank() end })

require('mini.colors').setup {}
require('mini.base16').setup {
    palette = util.colorschemes.gruvbox_material_dark_medium,
    use_cterm = true,
}

MiniMisc.setup_termbg_sync()

MiniColors.get_colorscheme()
    :add_transparency({
        general = true,
        float = true,
        statuscolumn = false,
        statusline = false,
        tabline = false,
        winbar = false,
    })
    :apply()
