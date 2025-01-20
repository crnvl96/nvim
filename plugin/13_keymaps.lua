-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n

Utils.Keymap2('Search forward', {
  expr = true,
  lhs = 'n',
  rhs = "'Nn'[v:searchforward].'zv'",
})

Utils.Keymap2('Search forward', {
  expr = true,
  mode = { 'x', 'o' },
  lhs = 'n',
  rhs = "'Nn'[v:searchforward]",
})

Utils.Keymap2('Search backward', {
  expr = true,
  lhs = 'N',
  rhs = "'nN'[v:searchforward].'zv'",
})

Utils.Keymap2('Search backward', {
  expr = true,
  mode = { 'x', 'o' },
  lhs = 'N',
  rhs = "'nN'[v:searchforward]",
})

Utils.Keymap2('Better paste', {
  mode = 'x',
  lhs = 'p',
  rhs = 'P',
})

Utils.Keymap2('Move down', {
  mode = { 'n', 'x' },
  expr = true,
  lhs = 'j',
  rhs = [[v:count == 0 ? 'gj' : 'j']],
})

Utils.Keymap2('Move up', {
  mode = { 'n', 'x' },
  expr = true,
  lhs = 'k',
  rhs = [[v:count == 0 ? 'gk' : 'k']],
})

Utils.Keymap2('Clear highlight', {
  mode = { 'n', 'x', 'i' },
  lhs = '<Esc>',
  rhs = '<Esc><Cmd>nohl<CR><Esc>',
})

Utils.Keymap2('Window left', {
  lhs = '<C-h>',
  rhs = '<C-w>h',
})

Utils.Keymap2('Window down', {
  lhs = '<C-j>',
  rhs = '<C-w>j',
})

Utils.Keymap2('Window up', {
  lhs = '<C-k>',
  rhs = '<C-w>k',
})

Utils.Keymap2('Window right', {
  lhs = '<C-l>',
  rhs = '<C-w>l',
})

Utils.Keymap2('Resize height +', {
  remap = true,
  lhs = '<C-w>+',
  rhs = '<Cmd>resize +5<CR>',
})

Utils.Keymap2('Resize height -', {
  remap = true,
  lhs = '<C-w>-',
  rhs = '<Cmd>resize -5<CR>',
})

Utils.Keymap2('Resize width -', {
  remap = true,
  lhs = '<C-w><',
  rhs = '<Cmd>vertical resize -20<CR>',
})

Utils.Keymap2('Resize width +', {
  remap = true,
  lhs = '<C-w>>',
  rhs = '<Cmd>vertical resize +20<CR>',
})

Utils.Keymap2('Resize height +', {
  remap = true,
  lhs = '<C-Up>',
  rhs = '<Cmd>resize +5<CR>',
})

Utils.Keymap2('Resize height -', {
  remap = true,
  lhs = '<C-Down>',
  rhs = '<Cmd>resize -5<CR>',
})

Utils.Keymap2('Resize width -', {
  remap = true,
  lhs = '<C-Left>',
  rhs = '<Cmd>vertical resize -20<CR>',
})

Utils.Keymap2('Resize width +', {
  remap = true,
  lhs = '<C-Right>',
  rhs = '<Cmd>vertical resize +20<CR>',
})

Utils.Keymap2('Save', {
  mode = { 'n', 'i', 'x' },
  lhs = '<C-s>',
  rhs = '<Esc><Cmd>w<CR><Esc>',
})

Utils.Keymap2('Indent right', {
  mode = 'x',
  lhs = '>',
  rhs = '>gv',
})

Utils.Keymap2('Indent left', {
  mode = 'x',
  lhs = '<',
  rhs = '<gv',
})
