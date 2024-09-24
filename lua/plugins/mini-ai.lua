return {
    'echasnovski/mini.ai',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    opts = function()
        return {
            n_lines = 300,
            custom_textobjects = {
                f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
            },
            silent = true,
            search_method = 'cover',
            mappings = {
                around_next = '',
                inside_next = '',
                around_last = '',
                inside_last = '',
            },
        }
    end,
}
