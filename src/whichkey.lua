require('which-key').setup({
    preset = 'modern',
    show_help = false,
    show_keys = false,
    win = {
        border = 'none',
        title = false,
    },
    delay = 200,
    icons = { mappings = false },
    spec = {
        {
            mode = { 'n', 'v' },
            { '<leader>d', group = 'DAP' },
            { '<leader>f', group = 'Files' },
        },
    },
})
