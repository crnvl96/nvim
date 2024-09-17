return {
    {
        'ibhagwan/fzf-lua',
        cmd = 'FzfLua',
        opts = function()
            local actions = require('fzf-lua.actions')

            return {
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
                defaults = { file_icons = 'mini' },
                winopts = {
                    height = 0.7,
                    width = 0.55,
                    row = 0.50,
                    col = 0.50,
                    border = 'none',
                    backdrop = 60,
                    preview = {
                        scrollbar = false,
                        hidden = 'hidden',
                        vertical = 'up:50%',
                        layout = 'vertical',
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
                global_git_icons = false,
                files = {
                    winopts = {
                        preview = { hidden = 'hidden' },
                    },
                },
                grep = {
                    header_prefix = ' ',
                    rg_glob = false,
                    glob_flag = '--iglob', -- for case sensitive globs use '--glob'
                    glob_separator = '%s%-%-', -- query separator pattern (lua): ' --'
                },
                helptags = {
                    actions = {
                        -- Open help pages in a vertical split.
                        ['enter'] = actions.help_vert,
                    },
                },
                lsp = {
                    symbols = {
                        symbol_icons = {
                            Array = '󰅪',
                            Class = '',
                            Color = '󰏘',
                            Constant = '󰏿',
                            Constructor = '',
                            Enum = '',
                            EnumMember = '',
                            Event = '',
                            Field = '󰜢',
                            File = '󰈙',
                            Folder = '󰉋',
                            Function = '󰆧',
                            Interface = '',
                            Keyword = '󰌋',
                            Method = '󰆧',
                            Module = '',
                            Operator = '󰆕',
                            Property = '󰜢',
                            Reference = '󰈇',
                            Snippet = '',
                            Struct = '',
                            Text = '',
                            TypeParameter = '',
                            Unit = '',
                            Value = '',
                            Variable = '󰀫',
                        },
                    },
                },
                oldfiles = {
                    include_current_session = true,
                    winopts = {
                        preview = { hidden = 'hidden' },
                    },
                },
            }
        end,
        config = function(_, opts)
            local fzf = require('fzf-lua')

            fzf.setup(opts)
            fzf.register_ui_select()
        end,
        keys = {
            { '<leader>f', '', desc = 'Files' },
            { '<leader><space>', '<cmd>FzfLua<CR>', desc = 'Commands' },
            { '<leader>f<', '<cmd>FzfLua resume<cr>', desc = 'Resume last command' },
            {
                '<leader>fl',
                function()
                    require('fzf-lua').lgrep_curbuf({
                        winopts = {
                            height = 0.6,
                            width = 0.5,
                            preview = { vertical = 'up:70%' },
                        },
                    })
                end,
                desc = 'Grep current buffer',
            },
            { '<leader>fc', '<cmd>FzfLua highlights<cr>', desc = 'Highlights' },
            { '<leader>ff', function() require('fzf-lua').files() end, desc = 'Files' },
            { '<leader>fo', function() require('fzf-lua').oldfiles() end, desc = 'Oldfiles' },
            { '<leader>fh', function() require('fzf-lua').help_tags() end, desc = 'Help' },
            { '<leader>fg', function() require('fzf-lua').live_grep_glob() end, desc = 'Grep' },
            { '<leader>fg', function() require('fzf-lua').grep_visual() end, desc = 'Grep visual', mode = 'x' },
            { '<leader>fr', function() require('fzf-lua').live_grep_resume() end, desc = 'Lgrep resume' },
            { '<leader>fd', function() require('fzf-lua').dap_commands() end, desc = 'Dap commands' },
            { '<leader>fD', function() require('fzf-lua').dap_configurations() end, desc = 'Dap configs' },
        },
    },
}
