return {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    config = function()
        require('fzf-lua').register_ui_select()

        require('fzf-lua').setup({
            fzf_opts = {
                ['--info'] = 'default',
                ['--layout'] = 'reverse-list',
                ['--cycle'] = '',
            },
            winopts = {
                preview = {
                    scrollbar = false,
                    hidden = 'hidden',
                    vertical = 'up:70%',
                    layout = 'vertical',
                },
            },
            keymap = {
                fzf = {
                    true,
                    ['ctrl-d'] = 'half-page-down',
                    ['ctrl-u'] = 'half-page-up',
                    ['ctrl-f'] = 'preview-page-down',
                    ['ctrl-b'] = 'preview-page-up',
                    ['ctrl-a'] = 'select-all',
                    ['ctrl-o'] = 'toggle-all',
                },
            },
            defaults = { file_icons = 'mini' },
            grep = { rg_glob = true },
            oldfiles = { include_current_session = true },
        })
    end,
    keys = {
        { '<Leader>f,', '<cmd>FzfLua<CR>', desc = 'Menu' },
        { '<Leader>fl', '<cmd>FzfLua lgrep_curbuf<CR>', desc = 'Grep buffer' },
        { '<Leader>f>', '<cmd>FzfLua resume<CR>', desc = 'Resume' },
        { '<Leader>fk', '<cmd>FzfLua keymaps<CR>', desc = 'Maps' },
        { '<Leader>fc', '<cmd>FzfLua highlights<CR>', desc = 'Highlights' },
        { '<Leader>ff', '<cmd>FzfLua files<CR>', desc = 'Files' },
        { '<Leader>fo', '<cmd>FzfLua oldfiles<CR>', desc = 'Oldfiles' },
        { '<Leader>fh', '<cmd>FzfLua help<CR>', desc = 'Help' },
        { '<Leader>fg', '<cmd>FzfLua live_grep_native<CR>', desc = 'Grep' },
        { '<Leader>fg', '<cmd>FzfLua grep_visual<CR>', desc = 'Grep visual', mode = 'x' },
        { '<Leader>fr', '<cmd>FzfLua live_grep_resume<CR>', desc = 'Resume last grep' },
        { '<Leader>fx', '<cmd>FzfLua quickfix<CR>', desc = 'Quickfix' },
    },
}
