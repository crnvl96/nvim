MiniDeps.add({ source = 'stevearc/quicker.nvim' })

local quicker = require('quicker')
quicker.setup({
    opts = {
        buflisted = false,
        number = false,
        relativenumber = false,
        signcolumn = 'auto',
        winfixheight = true,
        wrap = false,
    },
    keys = {
        { '>', function() quicker.expand({ before = 2, after = 2, add_to_existing = true }) end, desc = 'expand' },
        { '<', function() quicker.collapse() end, desc = 'collapse' },
    },
})

vim.keymap.set('n', '<leader>xx', function() quicker.toggle() end, { desc = 'quickfix' })
vim.keymap.set('n', '<leader>xl', function() quicker.toggle({ loclist = true }) end, { desc = 'loclist' })
