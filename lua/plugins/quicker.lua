return {
    'stevearc/quicker.nvim',
    ft = 'qf',
    opts = {
        borders = {
            vert = '│',
        },
    },
    config = function(_, opts)
        require('quicker').setup(opts)

        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup(vim.g.whoami .. '/fugitive_group', {}),
            pattern = { 'qf' },
            callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
        })
    end,
    keys = function()
        return {
            { '<leader>xx', function() require('quicker').toggle() end, desc = 'toggle' },
            {
                '>',
                function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end,
                desc = 'inc context',
            },
            { '<', function() require('quicker').collapse() end, desc = 'dec context' },
            {
                '<leader>xd',
                function()
                    local quicker = require('quicker')

                    if quicker.is_open() then
                        quicker.close()
                    else
                        vim.diagnostic.setqflist()
                    end
                end,
                desc = 'toggle diagnostics',
            },
        }
    end,
}
