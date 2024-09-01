local add = MiniDeps.add

add({ source = 'junegunn/fzf', hooks = { post_checkout = function() vim.fn['fzf#install']() end } })
add({ source = 'kevinhwang91/nvim-bqf' })

require('bqf').setup({
    preview = {
        win_height = 20,
        win_vheight = 20,
        delay_syntax = 80,
        show_title = false,
        should_preview_cb = function(bufnr)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
                ret = false
            elseif bufname:match('^fugitive://') then
                ret = false
            end
            return ret
        end,
    },
    func_map = {
        split = '<M-s>',
        vsplit = '<M-v>',
    },
})
