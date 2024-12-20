local miniclue = require('mini.clue')

miniclue.setup({
  clues = {
    { mode = 'n', keys = '<leader>b', desc = '+buffer' },
    { mode = 'n', keys = '<leader>c', desc = '+code' },
    { mode = 'n', keys = '<leader>d', desc = '+dap' },
    { mode = 'n', keys = '<leader>f', desc = '+files' },
    { mode = 'n', keys = '<leader>g', desc = '+git' },
    { mode = 'n', keys = '<leader>m', desc = '+map' },
    { mode = 'n', keys = '<leader>v', desc = '+visits' },
    { mode = 'n', keys = '<leader>x', desc = '+qf' },

    { mode = 'x', keys = '<leader>c', desc = '+code' },
    { mode = 'x', keys = '<leader>d', desc = '+dap' },
    { mode = 'x', keys = '<leader>g', desc = '+git' },

    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows({ submode_resize = true }),
    miniclue.gen_clues.z(),
  },
  triggers = {
    { mode = 'n', keys = '<Leader>' }, -- Leader triggers
    { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = [[\]] }, -- mini.basics
    { mode = 'n', keys = '[' }, -- mini.bracketed
    { mode = 'n', keys = ']' },
    { mode = 'x', keys = '[' },
    { mode = 'x', keys = ']' },
    { mode = 'i', keys = '<C-x>' }, -- Built-in completion
    { mode = 'n', keys = 'g' }, -- `g` key
    { mode = 'x', keys = 'g' },
    { mode = 'n', keys = "'" }, -- Marks
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },
    { mode = 'n', keys = '"' }, -- Registers
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' }, -- Window commands
    { mode = 'n', keys = 'z' }, -- `z` key
    { mode = 'x', keys = 'z' },
  },
  window = {
    delay = 200,
    config = { border = 'double', width = 'auto' },
  },
})
