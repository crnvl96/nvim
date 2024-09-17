return {
    {
        'stevearc/oil.nvim',
        cmd = 'Oil',
        opts = function()
            local detail = false

            return {
                columns = { 'icon' },
                watch_for_changes = true,
                keymaps = {
                    ['<C-s>'] = false,
                    ['<C-h>'] = false,
                    ['<C-l>'] = false,
                    ['<M-v>'] = {
                        'actions.select',
                        opts = { vertical = true },
                        desc = 'Open the entry in a vertical split',
                    },
                    ['<M-s>'] = {
                        'actions.select',
                        opts = { horizontal = true },
                        desc = 'Open the entry in a horizontal split',
                    },
                    ['gd'] = {
                        desc = 'Toggle file detail view',
                        callback = function()
                            detail = not detail
                            if detail then
                                require('oil').set_columns({ 'icon', 'permissions', 'size', 'mtime' })
                            else
                                require('oil').set_columns({ 'icon' })
                            end
                        end,
                    },
                },
            }
        end,
        config = function(_, opts) require('oil').setup(opts) end,
        keys = {
            { '-', function() require('oil').open() end, desc = 'oil' },
        },
    },
}
