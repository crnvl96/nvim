return {
    'MagicDuck/grug-far.nvim',
    config = function()
        require('grug-far').setup({ headerMaxWidth = 80 })

        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup(vim.g.whoami .. '/mini_git_setup', { clear = true }),
            pattern = { 'grug-far' },
            callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
        })
    end,
    cmd = 'GrugFar',
    keys = {
        {
            '<leader>c%',
            function()
                local grug = require('grug-far')
                local path = vim.bo.buftype == '' and vim.fn.expand('%')
                grug.open({
                    transient = true,
                    prefills = {
                        filesFilter = path or nil,
                    },
                })
            end,
            mode = { 'n', 'v' },
            desc = 'Search and Replace',
        },
    },
}
