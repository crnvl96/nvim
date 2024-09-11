local add = MiniDeps.add

add({ source = 'MagicDuck/grug-far.nvim' })

require('grug-far').setup({ headerMaxWidth = 80 })

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'grug-far' },
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/setup_grugfar_buf_triggers', {}),
    callback = function(e)
        require('mini.clue').ensure_buf_triggers(e.buf)
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { desc = 'close with <esc>', buffer = true })
    end,
})

vim.keymap.set('n', '<leader>fr', '<cmd>GrugFar<cr>', { desc = 'replace' })
