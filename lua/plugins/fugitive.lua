return {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G' },
    config = function()
        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup(vim.g.whoami .. '/fugitive_group', {}),
            pattern = { 'fugitive', 'fugitiveblame', 'git', 'gitcommit' },
            callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
        })
    end,
    keys = function()
        return {
            { '<leader>gg', '<cmd>Git<CR>', desc = 'git' },
            { '<leader>gd', '<cmd>Gvdiffsplit!<CR>', desc = 'diff' },
            { '<leader>gl', '<cmd>G log --oneline -256<CR>', desc = 'log' },
            { '<leader>gc', '<cmd>G commit --no-verify<CR>', desc = 'commit' },
        }
    end,
}
