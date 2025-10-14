---@class Util.Ui
local M = {}

---@class Util.Ui.Colorschemes
M.colorschemes = {
    gruvbox_material_dark_medium = {
        base00 = '#292828',
        base01 = '#32302f',
        base02 = '#504945',
        base03 = '#665c54',
        base04 = '#bdae93',
        base05 = '#ddc7a1',
        base06 = '#ebdbb2',
        base07 = '#fbf1c7',
        base08 = '#ea6962',
        base09 = '#e78a4e',
        base0A = '#d8a657',
        base0B = '#a9b665',
        base0C = '#89b482',
        base0D = '#7daea3',
        base0E = '#d3869b',
        base0F = '#bd6f3e',
    },
}

vim.opt.fillchars = {
    foldopen = '',
    foldclose = '',
    fold = '╌',
    foldsep = ' ',
    diff = '╱',
    eob = '~',
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
    tab = '> ',
    trail = '·',
}

vim.o.foldlevel = 10
vim.o.foldmethod = 'indent'
vim.o.foldnestmax = 10
vim.o.foldtext = ''

vim.api.nvim_create_autocmd('TextYankPost', { callback = function() (vim.hl or vim.highlight).on_yank() end })

require('mini.colors').setup {}

require('mini.base16').setup {
    palette = M.colorschemes.gruvbox_material_dark_medium,
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
