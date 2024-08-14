local bqf = require('bqf')
bqf.setup({
    preview = {
        win_height = 20,
        win_vheight = 20,
        delay_syntax = 80,
        show_title = false,
        should_preview_cb = function(bufnr)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
                ret = false
            elseif bufname:match('^fugitive://') then
                ret = false
            end
            return ret
        end,
    },
})

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
