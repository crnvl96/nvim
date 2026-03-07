-- stylua: ignore
Config.now(function()
  Config.clues = {
    { mode = 'n', keys = '<leader>a', desc = '+AI' },
    { mode = 'n', keys = '<leader>b', desc = '+Buffers' },
    { mode = 'n', keys = '<leader>c', desc = '+Claude' },
    { mode = 'n', keys = '<leader>e', desc = '+Explorer' },
    { mode = 'n', keys = '<leader>f', desc = '+Find' },
    { mode = 'n', keys = '<leader>l', desc = '+Lsp' },
    { mode = 'n', keys = '<leader>g', desc = '+Git' },
    { mode = 'n', keys = '<leader>t', desc = '+Term' },
    { mode = 'n', keys = '<leader>u', desc = '+Utils' },
    { mode = 'x', keys = '<leader>u', desc = '+Utils' },
  }

  vim.keymap.set({ 'n', 'x' }, 'j',         [[v:count == 0 ? 'gj' : 'j']],  { expr = true,    desc = 'Go down one visual line' })
  vim.keymap.set({ 'n', 'x' }, 'k',         [[v:count == 0 ? 'gk' : 'k']],  { expr = true,    desc = 'Go up one visual line' })
  vim.keymap.set({ 'n', 't' }, '<C-Left>',  '<Cmd>vertical resize -20<CR>', { noremap = true, desc = 'Decrease window width' })
  vim.keymap.set({ 'n', 't' }, '<C-Down>',  '<Cmd>resize -5<CR>',           { noremap = true, desc = 'Decrease window height' })
  vim.keymap.set({ 'n', 't' }, '<C-Up>',    '<Cmd>resize +5<CR>',           { noremap = true, desc = 'Increase window height' })
  vim.keymap.set({ 'n', 't' }, '<C-Right>', '<Cmd>vertical resize +20<CR>', { noremap = true, desc = 'Increase window width' })

  vim.keymap.set({ 'n', 'i', 'x' }, '<Esc>', '<Esc><Cmd>noh<CR><Esc>',                            { noremap = true, desc = 'Clear hlsearch on <Esc>' })
  vim.keymap.set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>silent! update | redraw<CR>', { noremap = true, desc = 'Clear hlsearch & save file' })

  vim.keymap.set('n', 'Y',     'yg_',       { noremap = true, desc = 'Yank till end of current line' })
  vim.keymap.set('x', 'p',     'P',         { noremap = true, desc = 'Paste in visual mode without overriding register', })
  vim.keymap.set('n', '<C-h>', '<C-w>h',    { noremap = true, desc = 'Go to left window' })
  vim.keymap.set('n', '<C-j>', '<C-w>j',    { noremap = true, desc = 'Go to window below' })
  vim.keymap.set('n', '<C-k>', '<C-w>k',    { noremap = true, desc = 'Go to window above' })
  vim.keymap.set('n', '<C-l>', '<C-w>l',    { noremap = true, desc = 'Go to right window' })
  vim.keymap.set('n', '<C-d>', '<C-d>zz',   { noremap = true, desc = 'Scroll down' })
  vim.keymap.set('n', '<C-u>', '<C-u>zz',   { noremap = true, desc = 'Scroll up' })
  vim.keymap.set('c', '<C-f>', '<Right>',   { noremap = true, desc = 'Move cursor to the right char' })
  vim.keymap.set('c', '<C-b>', '<Left>',    { noremap = true, desc = 'Move cursor to the left char' })
  vim.keymap.set('c', '<C-a>', '<Home>',    { noremap = true, desc = 'Move cursor to start of line' })
  vim.keymap.set('c', '<C-e>', '<End>',     { noremap = true, desc = 'Move cursor to end of line' })
  vim.keymap.set('c', '<C-g>', '<C-c>',     { noremap = true, desc = 'Quit/Exit from cmdline' })
  vim.keymap.set('c', '<M-h>', '<C-f>',     { noremap = true, desc = 'Access cmdline history' })
  vim.keymap.set('c', '<M-f>', '<C-Right>', { noremap = true, desc = 'Move cursor to left word' })
  vim.keymap.set('c', '<M-b>', '<C-Left>',  { noremap = true, desc = 'Move cursor to right word' })
end)
