vim.pack.add({ 'https://github.com/MagicDuck/grug-far.nvim' })

require('grug-far').setup({
  folding = { enabled = false },
  resultLocation = { showNumberLabel = false },
})

local function gf()
  local grug = require('grug-far')
  grug.open({ transient = true })
end

vim.keymap.set('n', '<Leader>us', gf, { desc = 'Grugfar' })
