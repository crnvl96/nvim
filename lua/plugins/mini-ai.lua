MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter-textobjects' })

local miniai = require('mini.ai')

miniai.setup({
    n_lines = 300,
    custom_textobjects = {
        f = miniai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
    },
    silent = true,
    search_method = 'cover',
    mappings = {
        around_next = '',
        inside_next = '',
        around_last = '',
        inside_last = '',
    },
})
