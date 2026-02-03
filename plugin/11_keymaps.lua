---@diagnostic disable: undefined-global

local now = MiniDeps.now

now(function()
    local set = vim.keymap.set

    set('!', '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { noremap = true })
    set('!', '<C-S>', '<Cmd>silent! update | redraw<CR>')

    set({ 'i', 'x' }, '<C-S>', '<Esc><Cmd>silent! update | redraw<CR>')
    set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
    set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

    set('v', 'p', 'P')
    set('n', '<C-h>', '<C-w>h')
    set('n', '<C-j>', '<C-w>j')
    set('n', '<C-k>', '<C-w>k')
    set('n', '<C-l>', '<C-w>l')
    set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
    set('n', '<C-Down>', '<Cmd>resize -5<CR>')
    set('n', '<C-Up>', '<Cmd>resize +5<CR>')
    set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
    set('n', '<C-d>', '<C-d>zz')
    set('n', '<C-u>', '<C-u>zz')
    set('n', 'n', 'nzz')
    set('n', 'N', 'Nzz')
    set('n', '*', '*zz')
    set('n', '#', '#zz')
    set('n', 'g*', 'g*zz')

    set('c', '<C-f>', '<Right>')
    set('c', '<C-b>', '<Left>')
    set('c', '<C-a>', '<Home>')
    set('c', '<C-e>', '<End>')
    set('c', '<M-f>', '<C-Right>')
    set('c', '<M-b>', '<C-Left>')
    set('c', '<C-d>', '<Del>')
    set('c', '<M-d>', '<C-w>')
    set('c', '<C-k>', '<C-u>')
    set('c', '<C-g>', '<C-c>')

    local function feedkeys(keys)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 't', true)
    end

    local function navigate_cmdline_next()
        feedkeys '<Tab>'
    end

    local function navigate_cmdline_prev()
        feedkeys '<S-Tab>'
    end

    set('c', '<C-n>', navigate_cmdline_next)
    set('c', '<C-p>', navigate_cmdline_prev)
end)
