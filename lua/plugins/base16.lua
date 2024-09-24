return {
    'echasnovski/mini.base16',
    lazy = false,
    priority = 1000,
    opts = { palette = vim.g.palette },
    config = function(_, opts)
        require('mini.base16').setup(opts)

        vim.api.nvim_create_autocmd('BufEnter', {
            group = vim.api.nvim_create_augroup(vim.g.whoami .. '/colorscheme', { clear = true }),
            callback = function()
                vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
                vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
            end,
        })
    end,
}
