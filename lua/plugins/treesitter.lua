MiniDeps.now(function()
  MiniDeps.add {
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd 'TSUpdate' end },
  }

  require('nvim-treesitter').setup {
    ensure_installed = {
      'c',
      'lua',
      'prisma',
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
