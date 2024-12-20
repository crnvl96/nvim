vim.cmd('setlocal spell wrap')

-- stylua: ignore
vim.keymap.set('n', '<Leader>mt', '<Cmd>MarkdownPreviewToggle<CR>', { desc = 'markdownpreview: toggle preview for document' })
