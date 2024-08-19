local tools = require('tools')

local treesitter = require('nvim-treesitter.configs')

treesitter.setup({
    ensure_installed = tools.ts_parsers,
    sync_install = false,
    auto_install = true,
    indent = { enable = true },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'markdown' },
    },
})

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
