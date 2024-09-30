return {
    { 'echasnovski/mini.extra' },
    {
        'echasnovski/mini.pick',
        cmd = 'Pick',
        lazy = false,
        config = function()
            require('mini.extra').setup()
            require('mini.pick').setup({
                options = {
                    use_cache = true,
                },
                window = {
                    prompt_cursor = '_',
                    prompt_prefix = '',
                },
            })

            vim.ui.select = require('mini.pick').ui_select
        end,
        keys = {
            { '<leader>ff', '<cmd>Pick files<CR>', desc = 'Pick files' },
            { '<leader>fl', '<cmd>Pick buf_lines<CR>', desc = 'Pick buflines' },
            { '<leader>fg', '<cmd>Pick grep_live<CR>', desc = 'Pick grep' },
            { '<leader>fd', '<cmd>Pick diagnostic<CR>', desc = 'Pick diagnostic' },
            { '<leader>fs', "<cmd>Pick lsp scope='document_symbol'<CR>", desc = 'Pick symbols' },
            { '<leader>fS', "<cmd>Pick lsp scope='workspace_symbol'<CR>", desc = 'Pick Symbols' },
            { '<leader>fh', '<cmd>Pick help<CR>', desc = 'Pick help' },
            { '<leader>fb', '<cmd>Pick buffers<CR>', desc = 'Pick buffers' },
            { '<leader>gb', '<cmd>Pick git_branches<CR>', desc = 'Pick branches' },
            { '<leader>gl', '<cmd>Pick git_commits<CR>', desc = 'Pick commits' },
            { '<leader>gh', '<cmd>Pick git_hunks<CR>', desc = 'Pick hunks' },
        },
    },
}
