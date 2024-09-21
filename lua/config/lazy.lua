local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require('config.opts')
require('config.keymaps')
require('config.autocmds')

require('lazy').setup({
    spec = {
        { import = 'plugins' },
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
                            vertical = 'up:0%',
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
                    files = {
                        winopts = {
                            preview = { hidden = 'hidden' },
                        },
                    },
                    grep = {
                        header_prefix = ' ',
                        rg_glob = true,
                        glob_flag = '--iglob',
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
                local lgrep_curbuf = function()
                    require('fzf-lua').lgrep_curbuf({
                        winopts = {
                            height = 0.6,
                            width = 0.5,
                            preview = { vertical = 'up:70%' },
                        },
                    })
                end

                return {
                    { '<leader>fl', lgrep_curbuf, desc = 'grep buffer' },
                    { '<leader>f<space>', '<cmd>FzfLua<CR>', desc = 'menu' },
                    { '<leader>f>', function() require('fzf-lua').resume() end, desc = 'resume' },
                    { '<leader>fk', function() require('fzf-lua').keymaps() end, desc = 'maps' },
                    { '<leader>fc', function() require('fzf-lua').highlights() end, desc = 'highlights' },
                    { '<leader>ff', function() require('fzf-lua').files({ cwd_prompt = false }) end, desc = 'files' },
                    { '<leader>fo', function() require('fzf-lua').oldfiles() end, desc = 'oldfiles' },
                    { '<leader>fh', function() require('fzf-lua').help_tags() end, desc = 'help' },
                    { '<leader>fg', function() require('fzf-lua').grep() end, desc = 'grep' },
                    { '<leader>fg', function() require('fzf-lua').grep_visual() end, desc = 'grep visual', mode = 'x' },
                    { '<leader>fr', function() require('fzf-lua').live_grep_resume() end, desc = 'resume grep' },
                    { '<leader>fx', function() require('fzf-lua').quickfix() end, desc = 'qf' },
                }
            end,
        },
        {
            'stevearc/oil.nvim',
            cmd = 'Oil',
            opts = function()
                return {
                    -- columns = { 'icon', 'permissions', 'size', 'mtime' },
                    columns = { 'icon' },
                    watch_for_changes = true,
                    keymaps = {
                        ['<C-s>'] = false,
                        ['<C-h>'] = false,
                        ['<C-l>'] = false,
                        ['<M-v>'] = {
                            'actions.select',
                            opts = { vertical = true },
                            desc = 'Open the entry in a vertical split',
                        },
                        ['<M-s>'] = {
                            'actions.select',
                            opts = { horizontal = true },
                            desc = 'Open the entry in a horizontal split',
                        },
                    },
                }
            end,
            config = function(_, opts) require('oil').setup(opts) end,
            keys = {
                { '-', function() require('oil').open() end, desc = 'oil' },
            },
        },
        {
            'tpope/vim-fugitive',
            cmd = { 'Git', 'G', 'Gvdiffsplit' },
            config = function()
                vim.api.nvim_create_autocmd('FileType', {
                    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/fugitive_group', {}),
                    pattern = { 'fugitive', 'fugitiveblame', 'git', 'gitcommit' },
                    callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
                })
            end,
        },
        {
            'christoomey/vim-tmux-navigator',
            keys = function()
                return {
                    { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
                    { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
                    { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
                    { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
                    { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
                }
            end,
        },
        {
            'echasnovski/mini.icons',
            config = function()
                require('mini.icons').setup()
                require('mini.icons').mock_nvim_web_devicons()
            end,
        },
        {

            'echasnovski/mini.base16',
            lazy = false,
            priority = 1000,
            opts = function()
                return {
                    palette = {
                        base00 = '#181818',
                        base01 = '#282828',
                        base02 = '#383838',
                        base03 = '#585858',
                        base04 = '#b8b8b8',
                        base05 = '#d8d8d8',
                        base06 = '#e8e8e8',
                        base07 = '#f8f8f8',
                        base08 = '#ab4642',
                        base09 = '#dc9656',
                        base0A = '#f7ca88',
                        base0B = '#a1b56c',
                        base0C = '#86c1b9',
                        base0D = '#7cafc2',
                        base0E = '#ba8baf',
                        base0F = '#a16946',
                    },
                }
            end,
            config = function(_, opts)
                vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
                vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })

                require('mini.base16').setup(opts)
            end,
        },
    },
    install = { colorscheme = { 'habamax' } },
    defaults = { lazy = true },
    checker = { enabled = false },
    change_detection = { enabled = false },
    rocks = { enabled = false },
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip',
                -- 'netrwPlugin',
                'rplugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
})
