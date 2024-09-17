return {
    {
        'tpope/vim-rhubarb',
        cmd = { 'Git', 'G' },
        dependencies = {
            { 'tpope/vim-fugitive' },
        },
        config = function()
            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup(vim.g.whoami .. '/fugitive_group', {}),
                pattern = { 'fugitive', 'fugitive-blame' },
                callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
            })
        end,
        keys = {
            { '<leader>g', '', desc = 'Git' },
            { '<leader>gg', '<cmd>Git<CR>', desc = 'Git' },
            { '<leader>gd', '<cmd>Gvdiffsplit!<CR>', desc = 'Diff' },
            { '<leader>gl', '<cmd>G log --oneline -256<CR>', desc = 'Log' },
        },
    },
}
