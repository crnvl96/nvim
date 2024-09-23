return {
    'echasnovski/mini.files',
    config = function()
        require('mini.files').setup({
            mappings = {
                show_help = '?',
                go_in_plus = '<CR>',
                go_out_plus = '-',
                go_in = '',
                go_out = '',
            },
            windows = { width_nofocus = 25 },
            options = { permanent_delete = false },
        })

        local function open_split(buf_id, lhs, direction)
            local function rhs()
                local window = require('mini.files').get_explorer_state().target_window
                if window == nil or require('mini.files').get_fs_entry().fs_type == 'directory' then return end
                local new_target_window

                vim.api.nvim_win_call(window, function()
                    vim.cmd(direction .. ' split')
                    new_target_window = vim.api.nvim_get_current_win()
                end)

                require('mini.files').set_target_window(new_target_window)
                require('mini.files').go_in({ close_on_file = true })
            end

            vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
        end

        vim.api.nvim_create_autocmd('User', {
            desc = 'Add rounded corners to minifiles window',
            pattern = 'MiniFilesWindowOpen',
            callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'rounded' }) end,
        })

        vim.api.nvim_create_autocmd('User', {
            desc = 'Add minifiles split keymaps',
            pattern = 'MiniFilesBufferCreate',
            callback = function(args)
                open_split(args.data.buf_id, '<C-s>', 'belowright horizontal')
                open_split(args.data.buf_id, '<C-v>', 'belowright vertical')
            end,
        })
    end,
    keys = {
        {
            '-',
            function()
                local bufname = vim.api.nvim_buf_get_name(0)
                local path = vim.fn.fnamemodify(bufname, ':p')

                if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
            end,
            desc = 'File explorer',
        },
    },
}
