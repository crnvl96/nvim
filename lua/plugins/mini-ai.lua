local deps = require('mini.deps')
local add = deps.add

add('nvim-treesitter/nvim-treesitter-textobjects')

local ai = require('mini.ai')
local gen_ai_spec = require('mini.extra').gen_ai_spec
ai.setup({
    n_lines = 500,
    custom_textobjects = {
        o = ai.gen_spec.treesitter({ -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
        f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
        g = gen_ai_spec.buffer(),
        d = gen_ai_spec.diagnostic(),
        i = gen_ai_spec.indent(),
        L = gen_ai_spec.line(),
        n = gen_ai_spec.number(),
    },
})
