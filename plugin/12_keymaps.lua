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

set('n', '<C-Up>', '<Cmd>resize +5<CR>', { remap = true })
set('n', '<C-Down>', '<Cmd>resize -5<CR>', { remap = true })
set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>', { remap = true })
set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>', { remap = true })

set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>w<CR><Esc>')

set('x', '>', '>gv')
set('x', '<', '<gv')

set('n', '<Leader>ba', '<Cmd>b#<CR>', { desc = 'Alternate buffer' })
set('n', '<Leader>bd', '<Cmd>bd<CR>', { desc = 'Delete current buffer' })

set('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Code action' })
set('n', '<Leader>le', '<Cmd>lua vim.lsp.buf.hover({border="rounded"})<CR>', { desc = 'Eval' })
set('n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.signature_help({border="rounded"})<CR>', { desc = 'Signature help' })
set('n', '<Leader>lj', '<Cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'Next diagnostic' })
set('n', '<Leader>lk', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'Previous diagnostic' })
set('n', '<Leader>ll', '<Cmd>lua vim.diagnostic.open_float({boder="rounded"})<CR>', { desc = 'Inspect diagnostic' })
set('n', '<Leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename symbol' })
