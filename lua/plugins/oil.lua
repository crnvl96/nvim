return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('oil').setup({
            delete_to_trash = true,
            watch_for_changes = true,
            keymaps = {
                ['g?'] = 'actions.show_help',
                ['<CR>'] = 'actions.select',
                ['<C-v>'] = {
                    'actions.select',
                    opts = { vertical = true },
                    desc = 'Open the entry in a vertical split',
                },
                ['<C-s>'] = {
                    'actions.select',
                    opts = { horizontal = true },
                    desc = 'Open the entry in a horizontal split',
                },
                ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
                ['<C-p>'] = 'actions.preview',
                ['<C-c>'] = 'actions.close',
                ['<C-l>'] = 'actions.refresh',
                ['-'] = 'actions.parent',
                ['_'] = 'actions.open_cwd',
                ['`'] = 'actions.cd',
                ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory' },
                ['gs'] = 'actions.change_sort',
                ['gx'] = 'actions.open_external',
                ['g.'] = 'actions.toggle_hidden',
                ['g\\'] = 'actions.toggle_trash',
            },
        })
    end,
    keys = {
        { '-', '<cmd>Oil<CR>', desc = 'Oil' },
    },
}
