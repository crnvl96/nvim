require('mini.bufremove').setup()

local function delete_other_buffers()
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if current ~= buf then require('mini.bufremove').wipeout(buf, true) end
    end

    vim.cmd('redraw!')
end

vim.keymap.set('n', '<leader>bd', '<cmd>lua MiniBufremove.delete(0, false)<CR>', { desc = 'Delete current buffer' })
vim.keymap.set('n', '<leader>bo', delete_other_buffers, { desc = 'Delete all other buffers ' })
