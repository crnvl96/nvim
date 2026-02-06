MiniDeps.now(function()
    vim.keymap.set('!', '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { noremap = true })
    vim.keymap.set('!', '<C-m>', '<CR>', { remap = true })

    vim.keymap.set({ 'n', 'i', 'x' }, '<C-S>', '<Esc><Cmd>silent! update | redraw<CR>')

    vim.keymap.set('n', 'L', ':', { remap = true })

    vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
    vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

    vim.keymap.set('v', 'p', 'P')
    vim.keymap.set('n', '<C-h>', '<C-w>h')
    vim.keymap.set('n', '<C-j>', '<C-w>j')
    vim.keymap.set('n', '<C-k>', '<C-w>k')
    vim.keymap.set('n', '<C-l>', '<C-w>l')
    vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
    vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
    vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
    vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
    vim.keymap.set('n', '<C-d>', '<C-d>zz')
    vim.keymap.set('n', '<C-u>', '<C-u>zz')
    vim.keymap.set('n', 'n', 'nzz')
    vim.keymap.set('n', 'N', 'Nzz')
    vim.keymap.set('n', '*', '*zz')
    vim.keymap.set('n', '#', '#zz')
    vim.keymap.set('n', 'g*', 'g*zz')

    vim.keymap.set('c', '<C-f>', '<Right>')
    vim.keymap.set('c', '<C-b>', '<Left>')
    vim.keymap.set('c', '<C-a>', '<Home>')
    vim.keymap.set('c', '<C-e>', '<End>')
    vim.keymap.set('c', '<M-f>', '<C-Right>')
    vim.keymap.set('c', '<M-b>', '<C-Left>')
    vim.keymap.set('c', '<C-d>', '<Del>')
    vim.keymap.set('c', '<M-d>', '<C-w>')
    vim.keymap.set('c', '<C-k>', '<C-u>')
    vim.keymap.set('c', '<C-g>', '<C-c>')

    local km = {
        nxt_item_cmdline = function()
            local key = vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
            vim.api.nvim_feedkeys(key, 't', true)
        end,
        prev_item_cmdline = function()
            local key = vim.api.nvim_replace_termcodes('<S-Tab>', true, false, true)
            vim.api.nvim_feedkeys(key, 't', true)
        end,
    }

    vim.keymap.set('c', '<C-n>', km.nxt_item_cmdline)
    vim.keymap.set('c', '<C-p>', km.prev_item_cmdline)
end)
