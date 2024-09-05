vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/highlight_on_yank', {}),
    callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/setup_format_opts', {}),
    callback = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'qf', 'gitsigns-blame', 'fugitive', 'fugitiveblame', 'grug-far' },
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/close_with_q', {}),
    callback = function() vim.keymap.set('n', 'q', '<cmd>close<cr>', { desc = 'close with <esc>', buffer = true }) end,
})

vim.api.nvim_create_autocmd('VimResized', {
    pattern = '*',
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/auto_resize_vim', {}),
    callback = function()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. vim.fn.tabpagenr())
    end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/colorscheme_fix', {}),
    callback = function()
        vim.api.nvim_set_hl(0, 'Flovim.api.nvim_set_hlatBorder', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })

        vim.cmd('highlight Winbar guibg=none')
    end,
})

-- go
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/go_opts', {}),
    pattern = { 'go' },
    callback = function() vim.cmd('setlocal shiftwidth=4 tabstop=4') end,
})
