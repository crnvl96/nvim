-- clojure
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/clj_plugins', {}),
    pattern = { 'clojure' },
    once = true,
    callback = function()
        MiniDeps.add('tpope/vim-dispatch')
        MiniDeps.add('clojure-vim/vim-jack-in')
        MiniDeps.add('radenling/vim-dispatch-neovim')
        MiniDeps.add('Olical/conjure')

        vim.cmd('setlocal shiftwidth=4 tabstop=4')
    end,
})

-- go
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/go_opts', {}),
    pattern = { 'go' },
    callback = function() vim.cmd('setlocal shiftwidth=4 tabstop=4') end,
})

-- lisp
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('lisp_plugins', {}),
    pattern = { 'lisp' },
    callback = function() vim.cmd('setlocal shiftwidth=4 tabstop=4') end,
})
