require('mini.pick').setup { source = { show = require('mini.pick').default_show } }

vim.keymap.set('n', '<Leader>f', '<Cmd>Pick files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<Leader>g', '<Cmd>Pick grep_live<CR>', { desc = 'Grep' })
vim.keymap.set('n', '<Leader>b', '<Cmd>Pick buffers include_current=false<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<Leader>l', "<Cmd>Pick buf_lines scope='current'<CR>", { desc = 'Lines' })

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local set = vim.keymap.set
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        local buf = e.buf

        set('n', 'gd', "<Cmd>Pick lsp scope='definition'<CR>", { buffer = buf })
        set('n', 'gD', "<Cmd>Pick lsp scope='declaration'<CR>", { buffer = buf })
        set('n', 'gr', "<Cmd>Pick lsp scope='references'<CR>", { buffer = buf })
        set('n', 'gi', "<Cmd>Pick lsp scope='implementation'<CR>", { buffer = buf })
        set('n', 'gy', "<Cmd>Pick lsp scope='type_definition'<CR>", { buffer = buf })
        set('n', 'ge', "<Cmd>Pick diagnostic scope='current'<CR>", { buffer = buf })
        set('n', 'gE', "<Cmd>Pick diagnostic scope='all'<CR>", { buffer = buf })
        set('n', 'gO', "<Cmd>Pick lsp scope='workspace_symbol'<CR>", { buffer = buf })
        set('n', 'gs', "<Cmd>Pick lsp scope='document_symbol'<CR>", { buffer = buf })
    end,
})
