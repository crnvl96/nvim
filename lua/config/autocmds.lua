vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/yank_highlight', { clear = true }),
    desc = 'Highlight on yank',
    callback = function() vim.highlight.on_yank({ priority = 250 }) end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/filetype_group', {}),
    pattern = { 'help' },
    callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/goto_last_loc', { clear = true }),
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

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/treesitter_folding', { clear = true }),
    desc = 'Enable Treesitter folding',
    callback = function(args)
        local bufnr = args.buf

        -- Because of perf, just use indentation for folding in huge files.
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if not ok or not stats or stats.size > vim.g.bigfile_size then
            vim.wo[0][0].foldmethod = 'indent'
            return
        end

        -- Check that Treesitter works.
        if not pcall(vim.treesitter.start, bufnr) then return end

        -- Enable Treesitter folding.
        vim.api.nvim_buf_call(bufnr, function()
            vim.wo[0][0].foldmethod = 'expr'
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.cmd.normal('zx')
        end)
    end,
})
