local add = MiniDeps.add

add('tpope/vim-fugitive')
add('tpope/vim-rhubarb')

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'fugitive', 'fugitiveblame' },
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/close_with_q', {}),
    callback = function() vim.keymap.set('n', 'q', '<cmd>close<cr>', { desc = 'close with <esc>', buffer = true }) end,
})
