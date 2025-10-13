local s = vim.keymap.set
local ex = function(mode, lhs, rhs) s(mode, lhs, rhs, { expr = true }) end

s('n', '<C-Down>', '<Cmd>resize -5<CR>')
s('n', '<C-Up>', '<Cmd>resize +5<CR>')
s('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
s('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
s('n', '<C-d>', '<C-d>zz')
s('n', '<C-u>', '<C-u>zz')
s('n', '<C-h>', '<C-w>h')
s('n', '<C-j>', '<C-w>j')
s('n', '<C-k>', '<C-w>k')
s('n', '<C-l>', '<C-w>l')
s('x', '<', '<gv')
s('x', '>', '>gv')
s('x', 'p', 'P')
s({ 'n', 'x', 'o' }, 'Y', 'yg_')
ex({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'")
ex({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'")

s('n', 'H', 'mzgggqG`z<Cmd>delmarks z<CR>zz')
s('x', 'H', 'gqzz')

s({ 'i', 'n', 's' }, '<esc>', function()
    vim.cmd.nohlsearch()
    return '<esc>'
end)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
s('n', 'n', "'Nn'[v:searchforward].'zv'")
s('x', 'n', "'Nn'[v:searchforward]")
s('o', 'n', "'Nn'[v:searchforward]")
s('n', 'N', "'nN'[v:searchforward].'zv'")
s('x', 'N', "'nN'[v:searchforward]")
s('o', 'N', "'nN'[v:searchforward]")

s('i', ',', ',<c-g>u')
s('i', '.', '.<c-g>u')
s('i', ';', ';<c-g>u')
s({ 'i', 'x', 'n' }, '<C-s>', '<Cmd>noh<CR><Esc><Cmd>write!<CR><Esc>')

local menu = vim.fn.wildmenumode

ex('c', '<m-left>', function() return menu() and '<C-e><c-left>' or '<c-left>' end)
ex('c', '<m-down>', function() return menu() and '<C-e><c-down>' or '<c-down>' end)
ex('c', '<m-up>', function() return menu() and '<C-e><c-up>' or '<c-up>' end)
ex('c', '<m-right>', function() return menu() and '<C-e><c-right>' or '<c-right>' end)

s('n', '<Leader>x', function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd 'cclose'
    else
        vim.cmd 'copen'
    end
end, { desc = 'Toggle Quickfix List' })
