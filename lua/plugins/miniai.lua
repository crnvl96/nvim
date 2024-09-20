return {
    {
        'echasnovski/mini.ai',
        event = 'VeryLazy',
        dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
        opts = function()
            local miniai = require('mini.ai')

            return {
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
            }
        end,
    },
}
