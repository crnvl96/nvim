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
        { '<Leader>fl', '<cmd>FzfLua lgrep_curbuf<CR>', desc = 'Grep buffer' },
        { '<Leader>fr', '<cmd>FzfLua resume<CR>', desc = 'Resume' },
        { '<Leader>ff', '<cmd>FzfLua files<CR>', desc = 'Files' },
        { '<Leader>fg', '<cmd>FzfLua live_grep_native<CR>', desc = 'Grep' },
        { '<Leader>fh', '<cmd>FzfLua helptags<CR>', desc = 'Helptags' },
    },
}
