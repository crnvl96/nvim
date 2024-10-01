return {
    'gcmt/vessel.nvim',
    config = function()
        require('vessel').setup({
            create_commands = true,
            commands = {
                view_marks = 'Marks',
                view_jumps = 'Jumps',
            },
        })
    end,
    keys = {
        { '<leader>mm', '<Plug>(VesselViewMarks)', desc = 'Show Marks' },
        { '<leader>mj', '<Plug>(VesselViewJumps)', desc = 'Show Jumps' },
    },
}
