local colorschemes = {
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
require('mini.colors').setup {}
require('mini.base16').setup { palette = colorschemes.gruvbox_material_dark_medium, use_cterm = true }
require('mini.bracketed').setup()
require('mini.jump').setup()
require('mini.move').setup()
require('mini.trailspace').setup()
require('mini.diff').setup { view = { style = 'sign' } }

MiniMisc.setup_restore_cursor()
MiniMisc.setup_auto_root()
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

require('mini.ai').setup {
    custom_textobjects = {
        g = MiniExtra.gen_ai_spec.buffer(),
        f = require('mini.ai').gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
        d = MiniExtra.gen_ai_spec.diagnostic(),
        i = MiniExtra.gen_ai_spec.indent(),
    },
    search_method = 'cover',
}

require('mini.hipatterns').setup {
    highlighters = {
        fixme = MiniExtra.gen_highlighter.words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
        hack = MiniExtra.gen_highlighter.words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
        todo = MiniExtra.gen_highlighter.words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
        note = MiniExtra.gen_highlighter.words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    },
}

require('mini.files').setup {
    content = { prefix = function() end },
    mappings = { go_in = '', go_in_plus = '<CR>', go_out = '', go_out_plus = '-' },
}

require('mini.clue').setup {
    triggers = {
        { mode = 'n', keys = '<leader>' },
        { mode = 'x', keys = '<leader>' },
    },
}

vim.keymap.set('n', '-', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
