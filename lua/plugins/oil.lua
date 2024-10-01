return {
    'stevearc/oil.nvim',
    config = function()
        require('oil').setup({
            delete_to_trash = true,
            watch_for_changes = true,
            keymaps = {
                ['<C-v>'] = false,
                ['<C-p>'] = false,
                ['<C-s>'] = false,
                ['<C-w>v'] = {
                    'actions.select',
                    opts = { vertical = true },
                    desc = 'Open the entry in a vertical split',
                },
                ['<C-w>s'] = {
                    'actions.select',
                    opts = { horizontal = true },
                    desc = 'Open the entry in a horizontal split',
                },
            },
        })

        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup(vim.g.whoami .. '/mini_git_setup', { clear = true }),
            pattern = { 'oil' },
            callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
        })
    end,
    keys = {
        { '-', '<cmd>Oil<CR>', desc = 'Oil' },
    },
}
