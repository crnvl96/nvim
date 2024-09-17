vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/yank_highlight', { clear = true }),
    desc = 'Highlight on yank',
    callback = function() vim.highlight.on_yank({ higroup = 'Visual', priority = 250 }) end,
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
