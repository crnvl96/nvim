Config.now(function()
  vim.keymap.set({ 'n', 'i', 'x' }, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { noremap = true })
  vim.keymap.set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>silent! update | redraw<CR>')

  vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
  vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

  vim.keymap.set('x', 'p', 'P')

  vim.keymap.set('t', '<C-g>', '<C-\\><C-n>')

  vim.keymap.set('c', '<M-h>', '<C-f>')

  vim.keymap.set('n', '<C-h>', '<C-w>h')
  vim.keymap.set('n', '<C-j>', '<C-w>j')
  vim.keymap.set('n', '<C-k>', '<C-w>k')
  vim.keymap.set('n', '<C-l>', '<C-w>l')
  vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
  vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
  vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
  vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
  vim.keymap.set('n', '<C-d>', '<C-d>zz')
  vim.keymap.set('n', '<C-u>', '<C-u>zz')
  vim.keymap.set('n', 'n', 'nzz')
  vim.keymap.set('n', 'N', 'Nzz')
  vim.keymap.set('n', '*', '*zz')
  vim.keymap.set('n', '#', '#zz')
  vim.keymap.set('n', 'g*', 'g*zz')

  -- Emacs like bindings
  vim.keymap.set('c', '<C-f>', '<Right>', { noremap = true })
  vim.keymap.set('c', '<C-b>', '<Left>')
  vim.keymap.set('c', '<C-a>', '<Home>')
  vim.keymap.set('c', '<C-e>', '<End>')
  vim.keymap.set('c', '<M-f>', '<C-Right>')
  vim.keymap.set('c', '<M-b>', '<C-Left>')
  vim.keymap.set('c', '<C-d>', '<Del>')
  vim.keymap.set('c', '<M-d>', '<C-w>')
  vim.keymap.set('c', '<C-k>', '<C-u>')
  vim.keymap.set('c', '<C-g>', '<C-c>')
end)

Config.later(function()
  Config.clues = {
    { mode = { 'n' }, keys = '<leader>e', desc = '+explorer' },
    { mode = { 'n' }, keys = '<leader>b', desc = '+buffers' },
    { mode = { 'n' }, keys = '<leader>g', desc = '+git' },
    { mode = { 'n', 'x' }, keys = '<leader>f', desc = '+find' },
    { mode = { 'n', 'x' }, keys = '<leader>l', desc = '+lsp' },
  }

  -- stylua: ignore start
  vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>')

  vim.keymap.set('n', '<Leader>ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>', { desc = 'Explorer' })
  vim.keymap.set('n', '<Leader>go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', { desc = 'Toggle overlay' })
  vim.keymap.set('n', '<Leader>gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', { desc = 'Show at selection' })
  vim.keymap.set('x', '<Leader>gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', { desc = 'Show at selection' })
end)
