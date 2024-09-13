vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/highlight_on_yank', {}),
    callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/goto_last_loc', {}),
    callback = function(event)
        local exclude = { 'gitcommit' }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then return end
        vim.b[buf].last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
    end,
})
