local deps = require('mini.deps')
local add = deps.add

add('NeogitOrg/neogit')

local neogit = require('neogit')
neogit.setup({
    disable_signs = true,
    graph_style = 'unicode',
    disable_line_numbers = false,
    kind = 'replace',
})

vim.keymap.set('n', '<Leader>gg', '<cmd>Neogit<CR>', { desc = 'Neogit' })
