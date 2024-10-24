local pick = require('mini.pick')

pick.setup({
  window = {
    config = {
      border = 'double',
    },
  },
})

vim.ui.select = pick.ui_select

vim.keymap.set('n', '<Leader>ff', '<Cmd>Pick files<CR>', { desc = 'Files' })
vim.keymap.set('n', '<Leader>fj', '<Cmd>Pick buffers include_current=false<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'Grep live' })
vim.keymap.set('n', '<Leader>fl', '<Cmd>Pick buf_lines scope="current"<CR>', { desc = 'Grep live' })
vim.keymap.set('n', '<Leader>fh', '<Cmd>Pick help<CR>', { desc = 'Help' })

vim.keymap.set({ 'n', 'x' }, '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Lsp code actions' })

vim.keymap.set('n', '<Leader>ld', '<Cmd>Pick lsp scope="definition"<CR>', { desc = 'Lsp definitions' })
vim.keymap.set('n', '<Leader>lr', '<Cmd>Pick lsp scope="references"<CR>', { desc = 'Lsp references' })
vim.keymap.set('n', '<Leader>ly', '<Cmd>Pick lsp scope="type_definition"<CR>', { desc = 'Lsp type definition' })
vim.keymap.set('n', '<Leader>li', '<Cmd>Pick lsp scope="implementation"<CR>', { desc = 'Lsp implementation' })
vim.keymap.set('n', '<Leader>ls', '<Cmd>Pick lsp scope="document_symbol"<CR>', { desc = 'Document symbols' })
