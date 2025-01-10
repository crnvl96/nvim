vim.cmd('setlocal spell wrap')

local set = vim.keymap.set

set('n', '<Leader>mt', '<Cmd>MarkdownPreviewToggle<CR>', { desc = 'Toggle preview' })
