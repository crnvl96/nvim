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
  opts = function()
    return {
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
    }
  end,
  config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
}
