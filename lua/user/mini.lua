---@class Mini
local M = {}

---@class Mini.Colorschemes
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

require('mini.extra').setup {}
require('mini.misc').setup {}
require('mini.align').setup {}
require('mini.splitjoin').setup {}

MiniMisc.setup_restore_cursor()
MiniMisc.setup_auto_root()
MiniMisc.setup_termbg_sync()

require('mini.colors').setup {}

require('mini.base16').setup {
    palette = M.colorschemes.gruvbox_material_dark_medium,
    use_cterm = true,
}

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

require('mini.bracketed').setup()
require('mini.indentscope').setup()
require('mini.jump').setup()
require('mini.move').setup()
require('mini.trailspace').setup()

local ai = require 'mini.ai'
ai.setup {
    custom_textobjects = {
        g = MiniExtra.gen_ai_spec.buffer(),
        f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
    },
    search_method = 'cover',
}

local hipatterns = require 'mini.hipatterns'
local hi_words = MiniExtra.gen_highlighter.words
hipatterns.setup {
    highlighters = {
        fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
        hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
        todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
        note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
}

require('mini.files').setup {
    content = { prefix = function() end },
    mappings = {
        close = 'q',
        go_in = '',
        go_in_plus = '<CR>',
        go_out = '',
        go_out_plus = '-',
        mark_goto = "'",
        mark_set = 'm',
        reset = '<BS>',
        reveal_cwd = '@',
        show_help = 'g?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
    },
}

vim.keymap.set('n', '-', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
