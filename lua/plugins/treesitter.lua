MiniDeps.now(function()
  MiniDeps.add 'nvim-treesitter/nvim-treesitter'

  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'c',
      'lua',
      'vim',
      'vimdoc',
      'query',
      'markdown',
      'markdown_inline',
      'javascript',
      'typescript',
      'tsx',
      'ruby',
      'python',
    },
    sync_install = false,
    ignore_install = {},
    highlight = { enable = true },
    indent = {
      enable = true,
      disable = { 'yaml' },
    },
  }
end)
