vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = vim.api.nvim_create_augroup('Crnvl96CheckTime', {}),
    callback = function()
        if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('Crnvl96HighlightOnYank', {}),
    callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd({ 'VimResized' }, {
    group = vim.api.nvim_create_augroup('Crnvl96AutoResize', {}),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. current_tab)
    end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('Crnvl96GoToLastLoc', {}),
    callback = function(event)
        local exclude = { 'gitcommit' }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].has_done_last_loc then return end
        vim.b[buf].has_done_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
    end,
})

vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('Crnvl96RegisterDynamicCapabilities', {}),
    callback = function() end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('Crnvl96DisableCompletion', {}),
    pattern = { 'clap_input' },
    callback = function(e) vim.b[e.buf].minicompletion_disable = true end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('Crnvl96CloseWithQ', {}),
    pattern = { 'fugitive', 'fugitiveblame', 'gitcommit', 'gitrebase', 'qf' },
    callback = function(e) vim.keymap.set('n', 'q', '<cmd>close!<CR>', { buffer = e.buf }) end,
})
