vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/highlight_on_yank', { clear = true }),
    callback = function() vim.highlight.on_yank({ priority = 250 }) end,
})

vim.api.nvim_create_autocmd('BufReadPre', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/goto_last_location', { clear = true }),
    callback = function(e)
        vim.api.nvim_create_autocmd('FileType', {
            buffer = e.buf,
            once = true,
            callback = function()
                if vim.bo.buftype ~= '' then return end
                if vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.bo.filetype) then return end

                local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
                if cursor_line > 1 then return end

                local mark_line = vim.api.nvim_buf_get_mark(0, [["]])[1]
                local n_lines = vim.api.nvim_buf_line_count(0)
                if not (1 <= mark_line and mark_line <= n_lines) then return end

                vim.cmd([[normal! g`"zv]])
                vim.cmd('normal! zz')
            end,
        })
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/close_with_q', { clear = true }),
    pattern = { 'qf', 'git', 'gitcommit', 'gitrebase', 'help' },
    callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
})

vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/fix_colorscheme', { clear = true }),
    callback = function()
        vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'StatusLine', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'StatusLineTerm', { link = 'Normal' })
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/treesitter_folding', { clear = true }),
    desc = 'Enable Treesitter folding',
    callback = function(e)
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(e.buf))
        if not ok or not stats or stats.size > (250 * 1024) then
            vim.wo[0][0].foldmethod = 'indent'
            return
        end

        if not pcall(vim.treesitter.start, e.buf) then return end

        vim.api.nvim_buf_call(e.buf, function()
            vim.wo[0][0].foldmethod = 'expr'
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.cmd.normal('zx')
        end)
    end,
})

local line_numbers_group = vim.api.nvim_create_augroup(vim.g.whoami .. '/toggle_line_numbers', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
    group = line_numbers_group,
    desc = 'Toggle relative line numbers on',
    callback = function()
        if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, 'i') then vim.wo.relativenumber = true end
    end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
    group = line_numbers_group,
    desc = 'Toggle relative line numbers off',
    callback = function(args)
        if vim.wo.nu then vim.wo.relativenumber = false end

        -- Redraw here to avoid having to first write something for the line numbers to update.
        if args.event == 'CmdlineEnter' then vim.cmd.redraw() end
    end,
})
