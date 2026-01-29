---@diagnostic disable: undefined-global

local now = MiniDeps.now

now(function()
  local set = vim.keymap.set

  local modes = { 'i', 'c', 'x', 's', 'n', 'o' }

  set(modes, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>w!<CR><Esc>')
  set(modes, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { noremap = true })
  set('v', 'p', 'P')
  set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
  set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
  set('n', '<C-h>', '<C-w>h')
  set('n', '<C-j>', '<C-w>j')
  set('n', '<C-k>', '<C-w>k')
  set('n', '<C-l>', '<C-w>l')
  set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
  set('n', '<C-Down>', '<Cmd>resize -5<CR>')
  set('n', '<C-Up>', '<Cmd>resize +5<CR>')
  set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
  set('n', '<C-d>', '<C-d>zz')
  set('n', '<C-u>', '<C-u>zz')
  set('n', 'n', 'nzz')
  set('n', 'N', 'Nzz')
  set('n', '*', '*zz')
  set('n', '#', '#zz')
  set('n', 'g*', 'g*zz')
  set('n', '<Leader>g', ':sil grep<space>')
  set('n', '<Leader>G', ':sil grep<space><space>%<left><left>')
  set('n', '<leader>f', ':find<space>', { desc = 'Fuzzy find' })

  set('c', '<C-f>', '<Right>')
  set('c', '<C-b>', '<Left>')
  set('c', '<C-a>', '<Home>')
  set('c', '<C-e>', '<End>')
  set('c', '<C-p>', '<Up>')
  set('c', '<C-n>', '<Down>')
  set('c', '<M-f>', '<C-Right>')
  set('c', '<M-b>', '<C-Left>')
  set('c', '<C-d>', '<Del>')
  set('c', '<M-d>', '<C-w>')
  set('c', '<C-k>', '<C-u>')
end)
