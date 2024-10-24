return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile', 'VeryLazy' },
  cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
  -- load treesitter early when opening a file from the cmdline
  lazy = vim.fn.argc(-1) == 0,
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treesitter** module to be loaded in time.
    -- Luckily, the only things that those plugins need are the custom queries, which we make available
    -- during startup.
    require('lazy.core.loader').add_to_rtp(plugin)
    require('nvim-treesitter.query_predicates')
  end,
  opts = {
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    ensure_installed = {
      'bash',

      -- vimdiff
      'diff',

      'html',

      -- markdown
      'markdown',
      'markdown_inline',

      'printf',
      'query',
      'regex',
      'toml',
      'vim',
      'vimdoc',
      'xml',
      'yaml',

      -- json
      'json',
      'jsonc',

      -- lua
      'lua',
      'luadoc',
      'luap',

      -- c
      'c',

      -- js/ts
      'jsdoc',
      'javascript',
      'tsx',
      'typescript',

      -- rust
      'rust',
      'ron',

      -- python
      'ninja',
      'rst',
      'python',
    },
  },
  config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
}
