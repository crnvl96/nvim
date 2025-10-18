-- stylua: ignore start
local set = vim.keymap.set

set('n', '-', '<Cmd>20 Lex<CR>')

set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')

set('x', 'p', 'P')
-- Paste linewise before/after current line

-- Usage: `yiw` to yank a word and `]p` to put it on the next line.
set('n', '[p', '<Cmd>exe "put! " . v:register<CR>', { desc='Paste Above' })
set('n', ']p', '<Cmd>exe "put "  . v:register<CR>', { desc='Paste Below' })

local new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

set('n', '<leader>bs', new_scratch_buffer, { desc='Scratch' })

-- Yank till end of line
set('n', 'Y', 'yg_')
set('x', 'Y', 'yg_')
set('o', 'Y', 'yg_')

-- The most common wayt of navigating from/to a terminal
set('t', '<C-h>', [[<C-\><C-N><C-w>h]])
set('t', '<C-j>', [[<C-\><C-N><C-w>j]])
set('t', '<C-k>', [[<C-\><C-N><C-w>k]])
set('t', '<C-l>', [[<C-\><C-N><C-w>l]])

set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
set("n", "<leader>uI", function() vim.treesitter.inspect_tree() vim.api.nvim_input("I") end, { desc = "Inspect Tree" })

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

set('n','<leader>tT', '<Cmd>horizontal term<CR>', {desc='Terminal (horizontal)'})
set('n','<leader>tt', '<Cmd>vertical term<CR>',   {desc='Terminal (vertical)'})

-- stylua: ignore end
