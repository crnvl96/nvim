MiniDeps.add('stevearc/oil.nvim')

require('oil').setup({
    watch_for_changes = true,
    keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-w>v'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
        ['<C-w>s'] = {
            'actions.select',
            opts = { horizontal = true },
            desc = 'Open the entry in a horizontal split',
        },
        ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
        ['<f4>'] = 'actions.preview',
        ['<C-c>'] = 'actions.close',
        ['<C-w>r'] = 'actions.refresh',
        ['-'] = 'actions.parent',
        ['@'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory', mode = 'n' },
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
    },
    use_default_keymaps = false,
    float = { border = 'none' },
    preview = { border = 'none' },
    progress = { border = 'none' },
    ssh = { border = 'none' },
    keymaps_help = { border = 'none' },
})

vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })
