return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  opts = {
    input = {
      border = 'double',
      mappings = {
        n = {
          ['<Esc>'] = 'Close',
          ['q'] = 'Close',
          ['<CR>'] = 'Confirm',
        },
      },
    },
  },
}
