return {
    'echasnovski/mini-git',
    cmd = 'Git',
    config = function()
        require('mini.git').setup({
            command = {
                split = 'vertical',
            },
        })

        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup(vim.g.whoami .. '/mini_git_setup', { clear = true }),
            pattern = { 'git', 'diff' },
            callback = function(e)
                vim.wo.foldexpr = 'v:lua.MiniGit.diff_foldexpr()'
                vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf })
            end,
        })

        vim.api.nvim_create_autocmd('User', {
            pattern = 'MiniGitCommandSplit',
            callback = function(e)
                if e.data.git_subcommand ~= 'blame' then return end

                local win_src = e.data.win_source
                vim.wo.wrap = false
                vim.fn.winrestview({ topline = vim.fn.line('w0', win_src) })
                vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0 })

                vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
            end,
        })

        vim.keymap.set(
            'ca',
            'G',
            function() return (vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == 'G') and 'Git' or 'G' end,
            { expr = true }
        )
    end,
    keys = {
        {
            '<leader>gd',
            function() require('mini.git').show_at_cursor({}) end,
            desc = 'Show info at cursor',
            mode = { 'n', 'x' },
        },
    },
}
