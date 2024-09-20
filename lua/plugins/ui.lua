return {
    {
        'echasnovski/mini.notify',
        event = 'LspAttach',
        config = function()
            require('mini.notify').setup({
                content = {
                    sort = function(notif_arr)
                        return require('mini.notify').default_sort(
                            vim.tbl_filter(
                                function(notif) return not vim.startswith(notif.msg, 'lua_ls: Diagnosing') end,
                                notif_arr
                            )
                        )
                    end,
                },
                window = { config = { border = 'double' } },
            })

            vim.notify = require('mini.notify').make_notify()
        end,
    },
    {
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
    },
    {
        'echasnovski/mini.icons',
        config = function()
            require('mini.icons').setup()
            require('mini.icons').mock_nvim_web_devicons()
        end,
    },
    {

        'echasnovski/mini.base16',
        lazy = false,
        priority = 1000,
        opts = function()
            return {
                palette = {
                    base00 = '#181818',
                    base01 = '#282828',
                    base02 = '#383838',
                    base03 = '#585858',
                    base04 = '#b8b8b8',
                    base05 = '#d8d8d8',
                    base06 = '#e8e8e8',
                    base07 = '#f8f8f8',
                    base08 = '#ab4642',
                    base09 = '#dc9656',
                    base0A = '#f7ca88',
                    base0B = '#a1b56c',
                    base0C = '#86c1b9',
                    base0D = '#7cafc2',
                    base0E = '#ba8baf',
                    base0F = '#a16946',
                },
            }
        end,
        config = function(_, opts)
            vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
            vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })

            require('mini.base16').setup(opts)
        end,
    },
}
