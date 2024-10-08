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
