vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/highlight_on_yank', { clear = true }),
    callback = function() vim.highlight.on_yank({ priority = 250 }) end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/close_with_q', { clear = true }),
    pattern = { 'help', 'qf', 'git', 'gitcommit' },
    callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = e.buf }) end,
})

vim.api.nvim_create_autocmd('BufReadPre', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/goto_last_location', { clear = true }),
    callback = function(e)
        vim.api.nvim_create_autocmd('FileType', {
            buffer = e.buf,
            once = true,
            callback = function()
                if vim.bo.buftype ~= '' then return end
                if vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.bo.filetype) then return end

                local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
                if cursor_line > 1 then return end

                local mark_line = vim.api.nvim_buf_get_mark(0, [["]])[1]
                local n_lines = vim.api.nvim_buf_line_count(0)
                if not (1 <= mark_line and mark_line <= n_lines) then return end

                vim.cmd([[normal! g`"zv]])
                vim.cmd('normal! zz')
            end,
        })
    end,
})
