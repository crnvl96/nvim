MiniDeps.add({ source = 'stevearc/oil.nvim' })

local oil = require('oil')
oil.setup({
    columns = { 'icon' },
    watch_for_changes = true,
    view_options = { show_hidden = true },
    keymaps = {
        ['<C-s>'] = false,
        ['<C-h>'] = false,
        ['<C-l>'] = false,
        ['<M-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
        ['<M-s>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
    },
})
