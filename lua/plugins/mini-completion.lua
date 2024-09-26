return {
    'echasnovski/mini.completion',
    event = 'InsertEnter',
    config = function()
        require('mini.completion').setup({
            delay = { completion = 100, info = 100, signature = 100 },
            window = {
                info = { height = 25, width = 80, border = 'rounded' },
                signature = { height = 25, width = 80, border = 'rounded' },
            },
            lsp_completion = {
                source_func = 'omnifunc',
                auto_setup = false,
                process_items = function(items, base)
                    items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
                    return require('mini.completion').default_process_items(items, base)
                end,
            },
            set_vim_settings = true,
        })
    end,
}
