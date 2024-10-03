return {
    {
        'tpope/vim-fugitive',
        cmd = { 'G', 'Git', 'Gvdiffsplit' },
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup(vim.g.whoami .. '/mini_git_setup', { clear = true }),
                pattern = { 'fugitive', 'fugitiveblame' },
                callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
            })
        end,
    },
}
