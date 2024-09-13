local detail = false

require('oil').setup({
    columns = { 'icon' },
    watch_for_changes = true,
    keymaps = {
        ['<C-s>'] = false,
        ['<C-h>'] = false,
        ['<C-l>'] = false,
        ['<M-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
        ['<M-s>'] = {
            'actions.select',
            opts = { horizontal = true },
            desc = 'Open the entry in a horizontal split',
        },
        ['gd'] = {
            desc = 'Toggle file detail view',
            callback = function()
                detail = not detail
                if detail then
                    require('oil').set_columns({ 'icon', 'permissions', 'size', 'mtime' })
                else
                    require('oil').set_columns({ 'icon' })
                end
            end,
        },
    },
})

require('fzf-lua').register_ui_select()

require('fzf-lua').setup({
    fzf_colors = {
        bg = { 'bg', 'Normal' },
        gutter = { 'bg', 'Normal' },
        info = { 'fg', 'Conditional' },
        scrollbar = { 'bg', 'Normal' },
        separator = { 'fg', 'Comment' },
    },
    fzf_opts = {
        ['--info'] = 'default',
        ['--layout'] = 'reverse-list',
        ['--cycle'] = '',
    },
    fzf_tmux_opts = {
        ['-p'] = '90%',
    },
    defaults = { file_icons = 'mini' },
    winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.50,
        col = 0.50,
        border = 'none',
        backdrop = 60,
        preview = {
            hidden = 'hidden',
            vertical = 'up:55%',
            horizontal = 'right:60%',
            layout = 'flex',
            flip_columns = 150,
        },
    },
    keymap = {
        fzf = {
            true,
            ['alt-u'] = 'unix-line-discard',
            ['ctrl-d'] = 'half-page-down',
            ['ctrl-u'] = 'half-page-up',
            ['ctrl-f'] = 'preview-page-down',
            ['ctrl-b'] = 'preview-page-up',
        },
        builtin = {
            true,
            ['<C-f>'] = 'preview-page-down',
            ['<C-b>'] = 'preview-page-up',
        },
    },
    grep = {
        -- Set to 'true' to always parse globs in both 'grep' and 'live_grep'
        -- search strings will be split using the 'glob_separator' and translated
        -- to '--iglob=' arguments, requires 'rg'
        -- can still be used when 'false' by calling 'live_grep_glob' directly
        rg_glob = false, -- default to glob parsing?
        glob_flag = '--iglob', -- for case sensitive globs use '--glob'
        glob_separator = '%s%-%-', -- query separator pattern (lua): ' --'
    },
})
