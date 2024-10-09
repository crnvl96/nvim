local function delete_other_buffers()
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if current ~= buf then require('mini.bufremove').wipeout(buf, true) end
    end

    vim.cmd('redraw!')
end

local hi_words = require('mini.extra').gen_highlighter.words

require('mini.bufremove').setup()

require('mini.hipatterns').setup({
    highlighters = {
        fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
        hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
        todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
        note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    },
})

vim.keymap.set('n', '<leader>bd', '<cmd>lua MiniBufremove.delete(0, false)<CR>', { desc = 'Delete current buffer' })
vim.keymap.set('n', '<leader>bo', delete_other_buffers, { desc = 'Delete all other buffers ' })
