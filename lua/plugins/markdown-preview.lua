return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = function()
    require('lazy').load({ plugins = { 'markdown-preview.nvim' } })
    vim.fn['mkdp#util#install']()
  end,
  config = function() vim.cmd([[do FileType]]) end,
  keys = {
    { '<leader>cp', '<cmd>MarkdownPreviewToggle<cr>', desc = 'markdown: preview', ft = 'markdown' },
  },
}
