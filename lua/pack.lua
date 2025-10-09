vim.pack.add {
    { src = 'https://github.com/nvim-mini/mini.nvim' },
    { src = 'https://github.com/tpope/vim-fugitive' },
    { src = 'https://github.com/folke/trouble.nvim' },
}

vim.api.nvim_create_user_command('PackClean', function()
    vim.pack.del(
        vim.iter(vim.pack.get())
            :filter(function(p) return not p.active end)
            :map(function(p) return p.spec.name end)
            :flatten()
            :totable()
    )
end, {})

vim.cmd 'packadd cfilter'
vim.cmd 'packadd nvim.undotree'

require('mini.extra').setup {}
require('mini.misc').setup {}
require('mini.align').setup {}
require('mini.splitjoin').setup {}

require('trouble').setup()

---@want?
---
--- Currently using trouble for that same behavior
--- If for some reason the old behavior is restored, move this code to lua/grep.lua
---
-- vim.api.nvim_create_autocmd('QuickFixCmdPost', {
--     pattern = '*grep*',
--     command = 'copen',
-- })

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    callback = function() vim.cmd [[Trouble qflist open]] end,
})

vim.keymap.set('n', '<leader>D', '<cmd>Trouble diagnostics toggle<cr>')
vim.keymap.set('n', '<leader>d', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>')
vim.keymap.set('n', '<leader>c', '<cmd>Trouble symbols toggle focus=false<cr>')
vim.keymap.set('n', '<leader>s', '<cmd>Trouble lsp toggle focus=false<cr>')

---@want?
---
--- Currently using trouble for this management
--- If we go back to using this, put this code on lua/keymaps.lua
---
-- set('n', '<Leader>x', function()
--     local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
--     if not success and err then vim.notify(err, vim.log.levels.ERROR) end
-- end, { desc = 'Toggle Quickfix List' })

vim.keymap.set('n', '<leader>x', '<cmd>Trouble qflist toggle<cr>')
