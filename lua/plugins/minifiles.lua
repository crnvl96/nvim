local function map_split(buf_id, lhs, direction)
    local minifiles = require('mini.files')

    local function rhs()
        local window = minifiles.get_explorer_state().target_window

        -- Noop if the explorer isn't open or the cursor is on a directory.
        if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then return end

        -- Make a new window and set it as target.
        local new_target_window
        vim.api.nvim_win_call(window, function()
            vim.cmd(direction .. ' split')
            new_target_window = vim.api.nvim_get_current_win()
        end)

        minifiles.set_target_window(new_target_window)

        -- Go in and close the explorer.
        minifiles.go_in({ close_on_file = true })
    end

    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
end

require('mini.files').setup({
    mappings = {
        show_help = '?',
        go_in_plus = '<cr>',
        go_out_plus = '-',
        go_in = '',
        go_out = '',
    },
    content = {
        filter = function(entry) return entry.fs_type ~= 'file' or entry.name ~= '.DS_Store' end,
        sort = function(entries)
            local function compare_alphanumerically(e1, e2)
                -- Put directories first.
                if e1.is_dir and not e2.is_dir then return true end
                if not e1.is_dir and e2.is_dir then return false end
                -- Order numerically based on digits if the text before them is equal.
                if e1.pre_digits == e2.pre_digits and e1.digits ~= nil and e2.digits ~= nil then
                    return e1.digits < e2.digits
                end
                -- Otherwise order alphabetically ignoring case.
                return e1.lower_name < e2.lower_name
            end

            local sorted = vim.tbl_map(function(entry)
                local pre_digits, digits = entry.name:match('^(%D*)(%d+)')
                if digits ~= nil then digits = tonumber(digits) end

                return {
                    fs_type = entry.fs_type,
                    name = entry.name,
                    path = entry.path,
                    lower_name = entry.name:lower(),
                    is_dir = entry.fs_type == 'directory',
                    pre_digits = pre_digits,
                    digits = digits,
                }
            end, entries)
            table.sort(sorted, compare_alphanumerically)
            -- Keep only the necessary fields.
            return vim.tbl_map(function(x) return { name = x.name, fs_type = x.fs_type, path = x.path } end, sorted)
        end,
    },
    windows = { width_nofocus = 25 },
    options = { permanent_delete = false },
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(e)
        local buf_id = e.data.buf_id
        map_split(buf_id, '<C-w>s', 'belowright horizontal')
        map_split(buf_id, '<C-w>v', 'belowright vertical')
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesActionDelete',
    callback = function(e)
        local target = e.data.to
        local buflist = vim.api.nvim_list_bufs()

        for _, buf in ipairs(buflist) do
            if vim.api.nvim_buf_get_name(buf) == target then
                require('mini.bufremove').wipeout(buf, true)
                vim.cmd('redraw!')
                return
            end
        end

        vim.cmd('redraw!')
    end,
})

vim.keymap.set('n', '-', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
end, { desc = 'File explorer' })
