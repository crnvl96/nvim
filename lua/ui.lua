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

-- require('vim._extui').enable { enable = true }

local s = vim.diagnostic.severity
vim.diagnostic.config {
    update_in_insert = false,
    virtual_lines = false,
    underline = { severity = { min = s.HINT, max = s.ERROR } },
    signs = { priority = 9999, severity = { min = s.WARN, max = s.ERROR } },
    virtual_text = { current_line = true, severity = { min = s.ERROR, max = s.ERROR } },
}

vim.api.nvim_create_autocmd('TextYankPost', { callback = function() (vim.hl or vim.highlight).on_yank() end })

vim.cmd.colorscheme 'retrobox'

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
