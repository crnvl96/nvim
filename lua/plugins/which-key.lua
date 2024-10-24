return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 100,
    preset = 'helix',
    triggers = {
      { '<auto>', mode = 'nixsotc' },
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
        {
          { '<Leader>gh', group = 'Hunks' },
        },
        { 'gr', group = 'LSP' },
        { 'gs', group = 'Surround' },
      },
    },
    win = {
      border = 'double',
      title = false,
    },
    icons = {
      mappings = false,
    },
    show_help = false,
    show_keys = false,
    disable = {
      ft = {},
      bt = {},
    },
  },
}
