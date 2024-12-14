return {
  'danymat/neogen',
  ft = { 'lua', 'python' },
  opts = {
    languages = {
      lua = { template = { annotation_convention = 'emmylua' } },
      python = { template = { annotation_convention = 'numpydoc' } },
    },
  },
}
