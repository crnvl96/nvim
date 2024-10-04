return {
    {
        'gcmt/vessel.nvim',
        config = function()
            local vessel = require('vessel')
            vessel.opt.window.options.border = 'rounded'
        end,
        keys = {
            { '<leader>mm', '<Plug>(VesselViewMarks)', desc = 'Show Marks' },
            { '<leader>mj', '<Plug>(VesselViewJumps)', desc = 'Show Jumps' },
            { '<leader>ms', '<Plug>(VesselSetGlobalMark)', desc = 'Set global mark' },
        },
    },
}
