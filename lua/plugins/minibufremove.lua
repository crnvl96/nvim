require('mini.bufremove').setup()

local keymaps = {
    {
        mode = 'n',
        lhs = '<leader>bd',
        rhs = function() MiniBufremove.delete(0, false) end,
        opts = {
            desc = 'Delete current buffer',
        },
    },
}

for _, map in ipairs(keymaps) do
    vim.keymap.set(map.mode, map.lhs, map.rhs, map.opts)
end
