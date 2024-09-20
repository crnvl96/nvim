return {
    'folke/which-key.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = function()
        return {
            preset = 'helix',
            icons = { mappings = false },
            delay = 200,
        }
    end,
    config = function(_, opts)
        local function extend_hl(name, def)
            local current_def = vim.api.nvim_get_hl(0, { name = name })
            local new_def = vim.tbl_extend('force', {}, current_def, def)

            vim.api.nvim_set_hl(0, name, new_def)
        end

        extend_hl('WhichKeyFloat', { link = 'Normal' })
        extend_hl('WhichKeyNormal', { link = 'Normal' })
        extend_hl('WhichKeySeparator', { link = 'Normal' })

        require('which-key').setup(opts)

        require('which-key').add({
            { '<leader>g', group = 'git' },
            { '<leader>d', group = 'debug' },
            { '<leader>f', group = 'files' },
            { '<leader>c', group = 'code' },
            { '<leader>x', group = 'quickfix' },
            { '<leader>h', group = 'hunks' },
            { '<leader>t', group = 'toggle' },
        })
    end,
    keys = function()
        return {
            {
                '<leader>?',
                function() require('which-key').show({ global = false }) end,
                desc = 'local keymaps',
            },
        }
    end,
}
