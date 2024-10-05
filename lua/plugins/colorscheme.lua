local deps = require('mini.deps')
local add = deps.add
add({ source = 'rose-pine/neovim', name = 'rose-pine' })

local rose_pine = require('rose-pine')
rose_pine.setup({
    -- dark_variant = 'moon',
    styles = {
        bold = true,
        italic = false,
        transparency = false,
    },
})

vim.cmd.colorscheme('rose-pine')
