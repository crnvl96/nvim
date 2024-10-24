return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'helix',
    icons = {
      mappings = false,
    },
    spec = {
      { '<Leader>b', group = 'Buffers' },
      { '<Leader>u', group = 'Toggle' },
      { '<Leader>f', group = 'Files' },
      { '<Leader>o', group = 'Overseer' },
      { '<Leader>x', group = 'Trouble' },
      {
        mode = { 'n', 'v' },
        { '<Leader>c', group = 'Code' },
        { '<Leader>d', group = 'Dap' },
        { '<Leader>i', group = 'IA' },
        { '<Leader>g', group = 'Git' },
        { '<Leader>l', group = 'LSP' },
        { '<Leader>s', group = 'Search' },
        { '<Leader>t', group = 'Neotest' },
        { 'gr', group = 'LSP' },
      },
    },
  },
}
