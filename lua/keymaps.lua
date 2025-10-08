local set = vim.keymap.set

set('n', '<C-Down>', '<Cmd>resize -5<CR>')
set('n', '<C-Up>', '<Cmd>resize +5<CR>')
set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')
set('n', '<C-h>', '<C-w>h')
set('n', '<C-j>', '<C-w>j')
set('n', '<C-k>', '<C-w>k')
set('n', '<C-l>', '<C-w>l')
set('x', '<', '<gv')
set('x', '>', '>gv')
set('x', 'p', 'P')
set({ 'n', 'x', 'o' }, 'Y', 'yg_')
set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

set('n', 'H', 'mzgggqG`z<cmd>delmarks z<cr>zz')
set('x', 'H', 'gqzz')

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
set({ 'i', 'x', 'n' }, '<C-s>', '<Cmd>noh<CR><Esc><Cmd>write!<CR><Esc>')
set('n', '<', vim.cmd.cprev)
set('n', '>', vim.cmd.cnext)

vim.cmd [[
    cnoremap  <expr>  <left>     wildmenumode()  ?  "\<C-e>\<left>"     :  "\<left>"
    cnoremap  <expr>  <down>     wildmenumode()  ?  "\<C-e>\<down>"     :  "\<down>"
    cnoremap  <expr>  <up>       wildmenumode()  ?  "\<C-e>\<up>"       :  "\<up>"
    cnoremap  <expr>  <right>    wildmenumode()  ?  "\<C-e>\<right>"    :  "\<right>"

    cnoremap  <expr>  <m-h>      wildmenumode()  ?  "\<C-e>\<left>"     :  "\<left>"
    cnoremap  <expr>  <m-j>      wildmenumode()  ?  "\<C-e>\<down>"     :  "\<down>"
    cnoremap  <expr>  <m-k>      wildmenumode()  ?  "\<C-e>\<up>"       :  "\<up>"
    cnoremap  <expr>  <m-l>      wildmenumode()  ?  "\<C-e>\<right>"    :  "\<right>"

    cnoremap  <expr>  <m-left>   wildmenumode()  ?  "\<C-e>\<c-left>"   :  "\<c-left>"
    cnoremap  <expr>  <m-down>   wildmenumode()  ?  "\<C-e>\<c-down>"   :  "\<c-down>"
    cnoremap  <expr>  <m-up>     wildmenumode()  ?  "\<C-e>\<c-up>"     :  "\<c-up>"
    cnoremap  <expr>  <m-right>  wildmenumode()  ?  "\<C-e>\<c-right>"  :  "\<c-right>"
]]

set('n', '<Leader>x', function()
    local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
    if not success and err then vim.notify(err, vim.log.levels.ERROR) end
end, { desc = 'Toggle Quickfix List' })
