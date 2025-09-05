require('snacks').setup({
  terminal = {
    win = { border = 'rounded' },
  },
})

vim.keymap.set({ 'n', 't' }, '<C-9>', function() Snacks.terminal() end)
vim.keymap.set({ 'n', 't' }, '<C-1>', function() Snacks.terminal('opencode') end)
vim.keymap.set({ 'n', 't' }, '<C-2>', function() Snacks.terminal('lazygit') end)
