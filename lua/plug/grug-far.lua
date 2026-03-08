vim.pack.add({
  'https://github.com/MagicDuck/grug-far.nvim',
})

require('grug-far').setup({
  folding = { enabled = false },
  resultLocation = { showNumberLabel = false },
})

local function grug_search_replace() require('grug-far').open({ transient = true }) end

vim.keymap.set({ 'n', 'x' }, '<Leader>ug', grug_search_replace, { desc = 'Search & Replace' })
