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

local s = vim.diagnostic.severity
vim.diagnostic.config {
    update_in_insert = false,
    virtual_lines = false,
    underline = false,
    signs = false,
    virtual_text = false,
    -- underline = { severity = { min = s.HINT, max = s.ERROR } },
    -- signs = { priority = 9999, severity = { min = s.WARN, max = s.ERROR } },
    -- virtual_text = { current_line = true, severity = { min = s.ERROR, max = s.ERROR } },
}

vim.api.nvim_create_autocmd('TextYankPost', { callback = function() (vim.hl or vim.highlight).on_yank() end })

vim.cmd [[
" seoul256 (dark):
"   Range:   233 (darkest) ~ 239 (lightest)
"   Default: 237


" seoul256 (light):
"   Range:   252 (darkest) ~ 256 (lightest)
"   Default: 253

let g:seoul256_background = 234
colo seoul256
]]

require('mini.colors').setup {}

MiniColors.get_colorscheme()
    :add_transparency({
        general = true,
        float = true,
        statuscolumn = true,
        statusline = true,
        tabline = true,
        winbar = true,
    })
    :apply()
