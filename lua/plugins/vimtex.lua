return {
  'lervag/vimtex',
  lazy = false, -- lazy-loading will disable inverse search
  config = function()
    vim.g.vimtex_compiler_method = 'tectonic'
    vim.g.vimtex_view_method = 'zathura'
  end,
  keys = {
    { '<Leader>K', '<plug>(vimtex-doc-package)', desc = 'tex: docs', silent = true, ft = 'tex' },
  },
}
