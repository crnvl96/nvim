vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/highlight_on_yank', {}),
    callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/setup_format_opts', {}),
    callback = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/exit_with_esc', {}),
    pattern = { 'qf', 'fzf' },
    callback = function() vim.keymap.set('t', '<esc><esc>', '<cmd>close<cr>', { desc = 'close with <esc>' }) end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/close_with_q', {}),
    pattern = { 'qf', 'gitsigns-blame', 'fugitive', 'fugitiveblame' },
    callback = function() vim.keymap.set('n', 'q', '<cmd>close<cr>', { desc = 'close with <esc>' }) end,
})

vim.api.nvim_create_autocmd('VimResized', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/auto_resize_vim', {}),
    callback = function()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. vim.fn.tabpagenr())
    end,
})
