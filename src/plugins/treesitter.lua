Add('nvim-treesitter/nvim-treesitter')

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
    disable = function(_, buf) return vim.tbl_contains({ 'tex', 'bigfile' }, vim.bo[buf].filetype) end,
  },
  indent = {
    enable = true,
  },
  sync_install = false,
  auto_install = true,
  ensure_installed = {
    'c',
    'lua',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'markdown_inline',

    -- js/ts
    'javascript',
    'typescript',
    'tsx',

    -- python
    'python',
  },
})
