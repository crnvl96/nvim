local set = vim.keymap.set

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true })
set('x', 'n', "'Nn'[v:searchforward]", { expr = true })
set('o', 'n', "'Nn'[v:searchforward]", { expr = true })
set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true })
set('x', 'N', "'nN'[v:searchforward]", { expr = true })
set('o', 'N', "'nN'[v:searchforward]", { expr = true })

set('i', ',', ',<C-g>u')
set('i', '.', '.<C-g>u')
set('i', ';', ';<C-g>u')

set('x', 'p', 'P')

set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

set('n', '<C-h>', '<C-w>h')
set('n', '<C-j>', '<C-w>j')
set('n', '<C-k>', '<C-w>k')
set('n', '<C-l>', '<C-w>l')

set('n', '<C-w>+', '<Cmd>resize +5<CR>', { remap = true })
set('n', '<C-w>-', '<Cmd>resize -5<CR>', { remap = true })
set('n', '<C-w><', '<Cmd>vertical resize -20<CR>', { remap = true })
set('n', '<C-w>>', '<Cmd>vertical resize +20<CR>', { remap = true })

set('n', 'K', [[<Cmd>lua vim.lsp.buf.hover({border="single"})<CR>]], { remap = true })

set({ 'n', 'v', 'i' }, '<Esc>', '<Esc><Cmd>nohl<CR><Esc>')
set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>w<CR><Esc>')

set('x', '>', '>gv')
set('x', '<', '<gv')
