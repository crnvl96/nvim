return {
    'vague2k/vague.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('vague').setup({
            style = {
                boolean = 'none',
                number = 'none',
                float = 'none',
                error = 'none',
                comments = 'none',
                conditionals = 'none',
                functions = 'none',
                headings = 'none',
                operators = 'none',
                strings = 'none',
                variables = 'none',
                keywords = 'none',
                keyword_return = 'none',
                keywords_loop = 'none',
                keywords_label = 'none',
                keywords_exception = 'none',
                builtin_constants = 'none',
                builtin_functions = 'none',
                builtin_types = 'none',
                builtin_variables = 'none',
            },
        })

        vim.cmd.colorscheme('vague')
    end,
}
