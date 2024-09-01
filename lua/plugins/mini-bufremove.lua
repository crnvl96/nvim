local bufremove = require('mini.bufremove')

bufremove.setup()

vim.keymap.set('n', '<leader>bc', function() require('mini.bufremove').delete(0, false) end, { desc = 'delete buffer' })

vim.keymap.set('n', '<leader>bo', function()
    local bcur = vim.api.nvim_get_current_buf()
    local blist = vim.api.nvim_list_bufs()

    for _, buf in ipairs(blist) do
        if buf ~= bcur then require('mini.bufremove').delete(buf, true) end
    end

    vim.cmd('redraw!')
end, { desc = 'delete other buffers' })
