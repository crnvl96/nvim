local function process_items(items, base)
    -- Don't show 'Text' and 'Snippet' suggestions
    items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
    return require('mini.completion').default_process_items(items, base)
end

require('mini.completion').setup({
    delay = { completion = 10 ^ 7, info = 100, signature = 50 },
    lsp_completion = {
        source_func = 'omnifunc',
        auto_setup = false,
        process_items = process_items,
    },
    window = {
        info = { border = 'rounded' },
        signature = { border = 'rounded' },
    },
    mappings = {
        force_twostep = '<C-n>',
        force_fallback = '<A-n>',
    },
})

if vim.fn.has('nvim-0.11') == 1 then vim.opt.completeopt:append('fuzzy') end
