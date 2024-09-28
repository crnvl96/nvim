return {
    'stevearc/quicker.nvim',
    ft = 'qf',
    config = function()
        require('quicker').setup({
            opts = {
                number = true,
                relativenumber = true,
                winfixheight = false,
            },
            keys = {
                {
                    '>',
                    "<cmd>lua require('quicker').expand({ before = 2, after = 2, add_to_existing = true })<CR>",
                    desc = 'Expand',
                },
                { '<', "<cmd>lua require('quicker').collapse()<CR>", desc = 'Collapse' },
            },
            edit = { enabled = true },
        })
    end,
    keys = {
        { '<leader>xx', "<cmd>lua require('quicker').toggle()<CR>", desc = 'Toggle' },
    },
}
