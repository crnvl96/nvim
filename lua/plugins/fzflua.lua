local add = MiniDeps.add

add({ source = 'ibhagwan/fzf-lua' })

local fzf = require('fzf-lua')

fzf.setup({
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

vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Files' })
vim.keymap.set('n', '<leader>fo', fzf.oldfiles, { desc = 'Oldfiles' })
vim.keymap.set('n', '<leader>fq', fzf.quickfix, { desc = 'Qf' })
vim.keymap.set('n', '<leader>fl', fzf.blines, { desc = 'Lines' })
vim.keymap.set('n', '<leader>ft', fzf.tabs, { desc = 'Tabs' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Lgrep' })
vim.keymap.set('n', '<leader>fG', fzf.live_grep_glob, { desc = 'Lgrep glob' })
vim.keymap.set('x', '<leader>fg', fzf.grep_visual, { desc = 'Lgrep visual' })
vim.keymap.set('n', '<leader>fr', fzf.live_grep_resume, { desc = 'Lgrep resume' })

fzf.register_ui_select()
