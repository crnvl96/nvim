return {
    { 'echasnovski/mini.icons' },
    {
        'echasnovski/mini.base16',
        lazy = false,
        priority = 1000,
        config = function()
            require('mini.base16').setup({ palette = vim.g.palette })
            require('mini.icons').setup()
            require('mini.icons').mock_nvim_web_devicons()
        end,
    },
    {
        'echasnovski/mini.notify',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require('mini.notify').setup({
                content = {
                    sort = function(notif_arr)
                        return require('mini.notify').default_sort(vim.tbl_filter(function(notif)
                            for _, msg in ipairs({ 'vtsls: Analyzing' }) do
                                if vim.startswith(notif.msg, msg) then return false end
                            end

                            return true
                        end, notif_arr))
                    end,
                },
                window = { config = { border = 'rounded' } },
                lsp_progress = { enable = true, duration_last = 1000 },
            })

            vim.notify = require('mini.notify').make_notify()
        end,
    },
}
