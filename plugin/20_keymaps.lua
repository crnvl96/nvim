Config.now(function()
  Config.clues = {
    { mode = { 'n' }, keys = '<leader>b', desc = '+Buffers' },
    { mode = { 'n' }, keys = '<leader>e', desc = '+Explorer' },
    { mode = { 'n', 'x' }, keys = '<leader>u', desc = '+Utils' },
    { mode = { 'n' }, keys = '<leader>f', desc = '+Find' },
    { mode = { 'n' }, keys = '<leader>l', desc = '+Lsp' },
    { mode = { 'n' }, keys = '<leader>g', desc = '+Git' },
    { mode = { 'n' }, keys = '<leader>t', desc = '+Term' },
  }

  Config.set(
    'n',
    'Y',
    'yg_',
    { noremap = true, desc = 'Yank Till End of Line' }
  )

  Config.set('x', 'p', 'P', { desc = 'Paste in Visual Mode' })

  Config.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
  Config.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

  Config.set(
    { 'n', 'i', 'x' },
    '<Esc>',
    '<Esc><Cmd>noh<CR><Esc>',
    { noremap = true }
  )

  Config.set(
    { 'n', 'i', 'x' },
    '<C-s>',
    '<Esc><Cmd>noh<CR><Cmd>silent! update | redraw<CR>'
  )

  Config.set('n', '<C-h>', '<C-w>h')
  Config.set('n', '<C-j>', '<C-w>j')
  Config.set('n', '<C-k>', '<C-w>k')
  Config.set('n', '<C-l>', '<C-w>l')

  Config.set({ 'n', 't' }, '<C-Left>', '<Cmd>vertical resize -20<CR>')
  Config.set({ 'n', 't' }, '<C-Down>', '<Cmd>resize -5<CR>')
  Config.set({ 'n', 't' }, '<C-Up>', '<Cmd>resize +5<CR>')
  Config.set({ 'n', 't' }, '<C-Right>', '<Cmd>vertical resize +20<CR>')

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
