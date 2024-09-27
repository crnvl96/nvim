return {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Git', 'Gvdiffsplit' },
    config = function()
        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup(vim.g.whoami .. '/mini_git_setup', { clear = true }),
            pattern = { 'fugitive', 'fugitiveblame' },
            callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
        })
    end,
    keys = {
        { '<leader>gB', '<cmd>Git blame -C -C -C<CR>', desc = 'Blame' },
        { '<leader>gP', '<cmd>Git push<CR>', desc = 'Push' },
        { '<leader>gl', '<cmd>Git log --oneline --graph -256<CR>', desc = 'Log' },
        { '<leader>gp', '<cmd>Git pull<CR>', desc = 'Pull' },
        { '<leader>gc', '<cmd>Git commit<CR>', desc = 'Commit' },
    },
}
