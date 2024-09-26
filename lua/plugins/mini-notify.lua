return {
    'echasnovski/mini.notify',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('mini.notify').setup({
            content = {
                sort = function(notif_arr)
                    local not_diagnosing = function(notif)
                        local ignore = {
                            -- 'lua_ls: Diagnosing',
                            'vtsls: Analyzing',
                        }

                        for _, msg in ipairs(ignore) do
                            if vim.startswith(notif.msg, msg) then return false end
                        end

                        return true
                    end

                    return require('mini.notify').default_sort(vim.tbl_filter(not_diagnosing, notif_arr))
                end,
            },
            window = { config = { border = 'rounded' } },
            lsp_progress = { enable = true, duration_last = 1000 },
        })

        vim.notify = require('mini.notify').make_notify()
    end,
}
