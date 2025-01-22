-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n

Utils.Keymap('Search forward', {
  expr = true,
  lhs = 'n',
  rhs = "'Nn'[v:searchforward].'zv'",
})

Utils.Keymap('Search forward', {
  expr = true,
  mode = { 'x', 'o' },
  lhs = 'n',
  rhs = "'Nn'[v:searchforward]",
})

Utils.Keymap('Search backward', {
  expr = true,
  lhs = 'N',
  rhs = "'nN'[v:searchforward].'zv'",
})

Utils.Keymap('Search backward', {
  expr = true,
  mode = { 'x', 'o' },
  lhs = 'N',
  rhs = "'nN'[v:searchforward]",
})

Utils.Keymap('Better paste', {
  mode = 'x',
  lhs = 'p',
  rhs = 'P',
})

Utils.Keymap('Move down', {
  mode = { 'n', 'x' },
  expr = true,
  lhs = 'j',
  rhs = [[v:count == 0 ? 'gj' : 'j']],
})

Utils.Keymap('Move up', {
  mode = { 'n', 'x' },
  expr = true,
  lhs = 'k',
  rhs = [[v:count == 0 ? 'gk' : 'k']],
})

Utils.Keymap('Clear highlight', {
  mode = { 'n', 'x', 'i' },
  lhs = '<Esc>',
  rhs = '<Esc><Cmd>nohl<CR><Esc>',
})

Utils.Keymap('Better Esc', {
  mode = { 'n', 'i', 'x', 'o', 't', 'c' },
  lhs = '<C-e>',
  rhs = function()
    local code_esc = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
    vim.api.nvim_feedkeys(code_esc, 'm', false)
  end,
})

Utils.Keymap('Window left', {
  lhs = '<C-h>',
  rhs = '<C-w>h',
})

Utils.Keymap('Window down', {
  lhs = '<C-j>',
  rhs = '<C-w>j',
})

Utils.Keymap('Window up', {
  lhs = '<C-k>',
  rhs = '<C-w>k',
})

Utils.Keymap('Window right', {
  lhs = '<C-l>',
  rhs = '<C-w>l',
})

Utils.Keymap('Resize height +', {
  remap = true,
  lhs = '<C-w>+',
  rhs = '<Cmd>resize +5<CR>',
})

Utils.Keymap('Resize height -', {
  remap = true,
  lhs = '<C-w>-',
  rhs = '<Cmd>resize -5<CR>',
})

Utils.Keymap('Resize width -', {
  remap = true,
  lhs = '<C-w><',
  rhs = '<Cmd>vertical resize -20<CR>',
})

Utils.Keymap('Resize width +', {
  remap = true,
  lhs = '<C-w>>',
  rhs = '<Cmd>vertical resize +20<CR>',
})

Utils.Keymap('Resize height +', {
  remap = true,
  lhs = '<C-Up>',
  rhs = '<Cmd>resize +5<CR>',
})

Utils.Keymap('Resize height -', {
  remap = true,
  lhs = '<C-Down>',
  rhs = '<Cmd>resize -5<CR>',
})

Utils.Keymap('Resize width -', {
  remap = true,
  lhs = '<C-Left>',
  rhs = '<Cmd>vertical resize -20<CR>',
})

Utils.Keymap('Resize width +', {
  remap = true,
  lhs = '<C-Right>',
  rhs = '<Cmd>vertical resize +20<CR>',
})

Utils.Keymap('Save', {
  mode = { 'n', 'i', 'x' },
  lhs = '<C-s>',
  rhs = '<Esc><Cmd>w<CR><Esc>',
})

Utils.Keymap('Indent right', {
  mode = 'x',
  lhs = '>',
  rhs = '>gv',
})

Utils.Keymap('Indent left', {
  mode = 'x',
  lhs = '<',
  rhs = '<gv',
})
