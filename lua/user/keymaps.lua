-- stylua: ignore start
local set = vim.keymap.set

set('n', '-', '<Cmd>20 Lex<CR>')

set('n', '<C-Down>',  '<Cmd>resize -5<CR>')
set('n', '<C-Up>',    '<Cmd>resize +5<CR>')
set('n', '<C-Left>',  '<Cmd>vertical resize -20<CR>')
set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')

set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')

set('n', '<C-h>', '<C-w>h')
set('n', '<C-j>', '<C-w>j')
set('n', '<C-k>', '<C-w>k')
set('n', '<C-l>', '<C-w>l')

set('x', 'p', 'P')

-- Yank till end of line
set('n', 'Y', 'yg_')
set('x', 'Y', 'yg_')
set('o', 'Y', 'yg_')

-- Move cursor visually down
set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
set('x', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Move cursor visually up
set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
set('x', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Smart save
set('n', '<C-s>', '<Cmd>noh<CR><Esc><Cmd>write!<CR><Esc>')
set('i', '<C-s>', '<Cmd>noh<CR><Esc><Cmd>write!<CR><Esc>')
set('x', '<C-s>', '<Cmd>noh<CR><Esc><Cmd>write!<CR><Esc>')

set('n', 'H', 'mzgggqG`z<Cmd>delmarks z<CR>zz')
set('x', 'H', 'gqzz')

local nohlsearch = function()
    vim.cmd.nohlsearch()
    return '<esc>'
end

-- Clear highlights
set('n', '<esc>', nohlsearch, { expr = true })
set('i', '<esc>', nohlsearch, { expr = true })
set('s', '<esc>', nohlsearch, { expr = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true })
set('x', 'n', "'Nn'[v:searchforward]",      { expr = true })
set('o', 'n', "'Nn'[v:searchforward]",      { expr = true })
set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true })
set('x', 'N', "'nN'[v:searchforward]",      { expr = true })
set('o', 'N', "'nN'[v:searchforward]",      { expr = true })

set('i', ',', ',<c-g>u')
set('i', '.', '.<c-g>u')
set('i', ';', ';<c-g>u')

local move_alt = function(k)
    return function()
        if vim.fn.wildmenumode() then
            return '<c-e>' .. k
        else
            return k
        end
    end
end

set('c', '<m-left>',  move_alt '<c-left>',  { expr = true })
set('c', '<m-down>',  move_alt '<c-down>',  { expr = true })
set('c', '<m-up>',    move_alt '<c-up>',    { expr = true })
set('c', '<m-right>', move_alt '<c-right>', { expr = true })

local qf_toggle = function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd 'cclose'
    else
        vim.cmd 'copen'
    end
end

set('n', '<Leader>x', qf_toggle, { desc = 'Toggle Quickfix List' })
-- stylua: ignore end
