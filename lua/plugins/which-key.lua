return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'helix',
    win = {
      border = 'none',
      title = false,
      padding = { 1, 2 },
    },
    icons = {
      mappings = false,
    },
    show_help = false,
    show_keys = false,
    spec = {
      {
        mode = { 'n' },
        { '<leader>b', group = 'buffers' },
        { '<leader>c', group = 'code' },
        { '<leader>f', group = 'files' },
        { '<leader>g', group = 'git' },
        { '<leader>i', group = 'ai' },
        { '<leader>l', group = 'lsp' },
        { '<leader>u', group = 'toggle' },
      },
      {
        mode = { 'v' },
        { '<leader>d', group = 'dap' },
        { '<leader>g', group = 'git' },
        { '<leader>i', group = 'ai' },
        { '<leader>l', group = 'lsp' },
      },
    },
  },
}
