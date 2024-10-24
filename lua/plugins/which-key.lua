return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'helix',
    win = {
      border = 'none',
      title = false,
    },
    -- Don't need icons for this
    icons = {
      mappings = false,
    },
    triggers = {
      { '<auto>', mode = 'nixsotc' },
      { '-', mode = { 'n' } },
    },
    -- Declutter the widow a little bit
    show_help = false,
    show_keys = false,
    spec = {
      -- Normal mode
      {
        mode = { 'n' },
        { '<leader>b', group = 'buffers' },
        { '<leader>c', group = 'code' },
        { '<leader>u', group = 'toggle' },
        { '<leader>f', group = 'files' },
        { '<leader>o', group = 'overseer' },
        { '<leader>x', group = 'trouble' },
      },
      {
        -- Normal and visual mode
        mode = { 'n', 'v' },
        { 'gr', group = 'lsp' },
        { '<leader>d', group = 'dap' },
        { '<leader>i', group = 'ia' },
        { '<leader>g', group = 'git' },
        { '<leader>l', group = 'lsp' },
      },
    },
  },
}
