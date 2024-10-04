return {
    {
        'echasnovski/mini.pick',
        cmd = 'Pick',
        dependencies = {
            { 'echasnovski/mini.extra', opts = {} },
            {
                'echasnovski/mini.visits',
                opts = {},
                keys = {
                    { '<leader>va', '<cmd>lua MiniVisits.add_label()<CR>', desc = 'Add label' },
                    { '<leader>vd', '<cmd>lua MiniVisits.remove_label()<CR>', desc = 'Remove label' },
                },
            },
        },
        opts = {
            options = {
                use_cache = true,
            },
            window = {
                prompt_cursor = '_',
                prompt_prefix = '',
                config = {
                    border = 'rounded',
                    height = math.floor(0.618 * vim.o.lines),
                    width = math.floor(0.850 * vim.o.columns),
                },
            },
        },
        config = function(_, opts)
            local pick = require('mini.pick')
            pick.setup(opts)
            vim.ui.select = pick.ui_select
        end,
        keys = {
            { '<leader>ff', '<cmd>Pick files<CR>', desc = 'Pick files' },
            { '<leader>fl', '<cmd>Pick buf_lines<CR>', desc = 'Pick buflines' },
            { '<leader>fv', '<cmd>Pick visit_paths<CR>', desc = 'Pick visit paths' },
            { '<leader>fm', '<cmd>Pick visit_labels<CR>', desc = 'Pick labels' },
            { '<leader>fg', '<cmd>Pick grep_live<CR>', desc = 'Pick grep' },
            { '<leader>fd', '<cmd>Pick diagnostic<CR>', desc = 'Pick diagnostic' },
            { '<leader>fs', "<cmd>Pick lsp scope='document_symbol'<CR>", desc = 'Pick symbols' },
            { '<leader>fS', "<cmd>Pick lsp scope='workspace_symbol'<CR>", desc = 'Pick Symbols' },
            { '<leader>fh', '<cmd>Pick help<CR>', desc = 'Pick help' },
            { '<leader>fr', '<cmd>Pick resume<CR>', desc = 'Pick resume' },
            { '<leader>fb', '<cmd>Pick buffers<CR>', desc = 'Pick buffers' },
        },
    },
}
