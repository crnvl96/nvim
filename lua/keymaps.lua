local set = vim.keymap.set

if vim.fn.has 'nvim-0.12' == 1 then
    set('c', '<C-n>', [[cmdcomplete_info().pum_visible ? "\<C-n>" : "\<Tab>"]], { expr = true })
    set('c', '<C-p>', [[cmdcomplete_info().pum_visible ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
end

set({ 'n', 't' }, '<C-Down>', '<Cmd>resize -5<CR>')
set({ 'n', 't' }, '<C-Up>', '<Cmd>resize +5<CR>')
set({ 'n', 't' }, '<C-Left>', '<Cmd>vertical resize -20<CR>')
set({ 'n', 't' }, '<C-Right>', '<Cmd>vertical resize +20<CR>')
set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')
set('n', '<C-h>', '<C-w>h')
set('n', '<C-j>', '<C-w>j')
set('n', '<C-k>', '<C-w>k')
set('n', '<C-l>', '<C-w>l')
set('t', '<C-h>', '<C-\\><C-n><C-w>h')
set('t', '<C-k>', '<C-\\><C-n><C-w>k')
set('t', '<C-l>', '<C-\\><C-n><C-w>l')
set('x', '<', '<gv')
set('x', '>', '>gv')
set('x', 'p', 'P')
set({ 'n', 'x', 'o' }, 'Y', 'yg_')
set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

set({ 'i', 'n', 's' }, '<esc>', function()
    vim.cmd 'noh'
    return '<esc>'
end, { expr = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true })
set('x', 'n', "'Nn'[v:searchforward]", { expr = true })
set('o', 'n', "'Nn'[v:searchforward]", { expr = true })
set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true })
set('x', 'N', "'nN'[v:searchforward]", { expr = true })
set('o', 'N', "'nN'[v:searchforward]", { expr = true })

set('i', ',', ',<c-g>u')
set('i', '.', '.<c-g>u')
set('i', ';', ';<c-g>u')
set({ 'i', 'x', 'n' }, '<C-s>', '<Cmd>noh<CR><Esc><Cmd>write!<CR><Esc>', {})
set('n', '[x', vim.cmd.cprev)
set('n', ']x', vim.cmd.cnext)
