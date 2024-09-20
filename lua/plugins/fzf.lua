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
                        ['ctrl-l'] = 'unix-line-discard',
                        ['ctrl-d'] = 'half-page-down',
                        ['ctrl-u'] = 'half-page-up',
                        ['ctrl-f'] = 'preview-page-down',
                        ['ctrl-b'] = 'preview-page-up',
                        ['alt-a'] = 'select-all',
                        ['alt-d'] = 'deselect-all',
                        ['alt-o'] = 'toggle-all',
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
            require('fzf-lua').setup(opts)
            require('fzf-lua').register_ui_select()
        end,
        keys = function()
            return {
                { '<leader>f<', function() require('fzf-lua').resume() end, desc = 'Resume last command' },
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
                { '<leader>fc', function() require('fzf-lua').highlights() end, desc = 'Highlights' },
                { '<leader>ff', function() require('fzf-lua').files() end, desc = 'Files' },
                { '<leader>fo', function() require('fzf-lua').oldfiles() end, desc = 'Oldfiles' },
                { '<leader>fh', function() require('fzf-lua').help_tags() end, desc = 'Help' },
                { '<leader>fg', function() require('fzf-lua').live_grep_glob() end, desc = 'Grep' },
                { '<leader>fg', function() require('fzf-lua').grep_visual() end, desc = 'Grep visual', mode = 'x' },
                { '<leader>fr', function() require('fzf-lua').live_grep_resume() end, desc = 'Lgrep resume' },
            }
        end,
    },
}
