vim.cmd('setlocal spell')
vim.cmd('setlocal wrap')

local has_mini_ai, mini_ai = pcall(require, 'mini.ai')

if has_mini_ai then
  vim.b.miniai_config = {
    custom_textobjects = {
      ['*'] = mini_ai.gen_spec.pair('*', '*', { type = 'greedy' }),
      ['_'] = mini_ai.gen_spec.pair('_', '_', { type = 'greedy' }),
    },
  }
end

vim.keymap.set('n', '<leader>cp', '<cmd>MarkdownPreviewToggle<cr>', { desc = '(markdown) mdp: toggle' })
