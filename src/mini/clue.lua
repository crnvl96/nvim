local miniclue = require('mini.clue')

miniclue.setup({
    clues = {
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
    window = { config = { width = 'auto', border = 'double' }, delay = 200 },
})
