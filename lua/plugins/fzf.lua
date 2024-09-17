return {
    {
        'ibhagwan/fzf-lua',
        cmd = 'FzfLua',
        opts = {
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
                rg_glob = false,
                glob_flag = '--iglob', -- for case sensitive globs use '--glob'
                glob_separator = '%s%-%-', -- query separator pattern (lua): ' --'
            },
        },
        config = function(_, opts)
            local fzf = require('fzf-lua')

            fzf.setup(opts)
            fzf.register_ui_select()
        end,
        keys = function()
            local fzf = require('fzf-lua')

            return {
                { '<leader><space>', '<cmd>FzfLua<CR>', desc = 'Commands' },
                { '<leader>f', '', desc = 'Files' },
                { '<leader>ff', fzf.files, desc = 'Files' },
                { '<leader>fo', fzf.oldfiles, desc = 'Oldfiles' },
                { '<leader>fg', fzf.live_grep_glob, desc = 'Grep' },
                { '<leader>fl', fzf.blines, desc = 'Lines' },
                { '<leader>fg', fzf.grep_visual, desc = 'Lgrep visual' },
                { '<leader>fr', fzf.live_grep_resume, desc = 'Lgrep resume' },
                { '<leader>fd', fzf.dap_commands, desc = 'Dap commands' },
                { '<leader>fD', fzf.dap_configurations, desc = 'Dap configs' },
                { '<leader>fR', fzf.resume, desc = 'Resume' },
            }
        end,
    },
}
