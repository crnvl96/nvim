require('mini.completion').setup({
    lsp_completion = {
        source_func = 'omnifunc',
        auto_setup = false,
        process_items = function(items, base)
            -- Don't show 'Text' and 'Snippet' suggestions
            items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
            return require('mini.completion').default_process_items(items, base)
        end,
    },
})

if vim.fn.has('nvim-0.11') == 1 then vim.opt.completeopt:append('fuzzy') end
local keycode = vim.keycode or function(x) return vim.api.nvim_replace_termcodes(x, true, true, true) end

vim.keymap.set('i', '<CR>', function()
    if vim.fn.pumvisible() ~= 0 then
        local info = vim.fn.complete_info()
        local item_selected = info.selected ~= -1
        return item_selected and keycode('<C-y>') or keycode('<C-y><CR>')
    end

    return keycode('<CR>')
end, { expr = true })
