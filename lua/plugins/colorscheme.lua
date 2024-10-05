return {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    opts = {
        dark_variant = 'moon',
        styles = {
            bold = true,
            italic = false,
            transparency = false,
        },
    },
    config = function(_, opts)
        local rose_pine = require('rose-pine')
        rose_pine.setup(opts)

        vim.cmd.colorscheme('rose-pine')
    end,
}
