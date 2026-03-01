Config.now(function()
  Config.clues = {
    { mode = { 'n' }, keys = '<leader>a', desc = '+ai' },
    { mode = { 'n' }, keys = '<leader>e', desc = '+explorer' },
    { mode = { 'n' }, keys = '<leader>t', desc = '+terms' },
    { mode = { 'n' }, keys = '<leader>t', desc = '+toggle' },
    { mode = { 'n' }, keys = '<leader>u', desc = '+utils' },
    { mode = { 'n' }, keys = '<leader>f', desc = '+find' },
    { mode = { 'n' }, keys = '<leader>l', desc = '+lsp' },
    { mode = { 'n' }, keys = '<leader>g', desc = '+git' },
  }

  Config.set('n', 'Y', 'yg_', { noremap = true })

  Config.set('x', 'p', 'P')

  Config.set('t', '<C-g>', '<C-\\><C-n>')

  Config.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
  Config.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

  Config.set({ 'n', 'i', 'x' }, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { noremap = true })
  Config.set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>silent! update | redraw<CR>')

  Config.set('n', '<C-h>', '<C-w>h')
  Config.set('n', '<C-j>', '<C-w>j')
  Config.set('n', '<C-k>', '<C-w>k')
  Config.set('n', '<C-l>', '<C-w>l')

  Config.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
  Config.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
  Config.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
  Config.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')

  Config.set('n', '<C-d>', '<C-d>zz')
  Config.set('n', '<C-u>', '<C-u>zz')

  Config.set('n', 'n', 'nzz')
  Config.set('n', 'N', 'Nzz')
  Config.set('n', '*', '*zz')
  Config.set('n', '#', '#zz')
  Config.set('n', 'g*', 'g*zz')

  Config.set('c', '<C-f>', '<Right>')
  Config.set('c', '<C-b>', '<Left>')
  Config.set('c', '<C-a>', '<Home>')
  Config.set('c', '<C-e>', '<End>')
  Config.set('c', '<C-d>', '<Del>')
  Config.set('c', '<C-k>', '<C-u>')
  Config.set('c', '<C-g>', '<C-c>')

  Config.set('c', '<M-d>', '<C-w>')
  Config.set('c', '<M-h>', '<C-f>')
  Config.set('c', '<M-f>', '<C-Right>')
  Config.set('c', '<M-b>', '<C-Left>')
end)
