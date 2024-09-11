vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/highlight_on_yank', {}),
    callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/setup_format_opts', {}),
    callback = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'qf' },
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/close_with_q', {}),
    callback = function() vim.keymap.set('n', 'q', '<cmd>close<cr>', { desc = 'close with <esc>', buffer = true }) end,
})

vim.api.nvim_create_autocmd('VimResized', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/auto_resize_vim', {}),
    callback = function()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. vim.fn.tabpagenr())
    end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/colorscheme_fix', {}),
    callback = function()
        vim.api.nvim_set_hl(0, 'Flovim.api.nvim_set_hlatBorder', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })

        vim.cmd('highlight Winbar guibg=none')
    end,
})

-- go to last loc when opening a buffer
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

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/auto_create_dir', {}),
    callback = function(event)
        if event.match:match('^%w%w+:[\\/][\\/]') then return end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})

vim.filetype.add({
    pattern = {
        ['.*'] = {
            function(path, buf)
                return vim.bo[buf]
                        and vim.bo[buf].filetype ~= 'bigfile'
                        and path
                        and vim.fn.getfsize(path) > vim.g.bigfile_size
                        and 'bigfile'
                    or nil
            end,
        },
    },
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/handle_bigfiles', {}),
    pattern = 'bigfile',
    callback = function(e)
        vim.schedule(function() vim.bo[e.buf].syntax = vim.filetype.match({ buf = e.buf }) or '' end)
    end,
})
