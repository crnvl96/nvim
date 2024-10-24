return {
  'stevearc/oil.nvim',
  opts = {
    delete_to_trash = true,
    cleanup_delay_ms = 1000,
    lsp_file_methods = {
      enabled = false,
    },
    watch_for_changes = true,
    use_default_keymaps = false,
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-w>v'] = { 'actions.select', opts = { vertical = true } },
      ['<C-w>s'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-w>t'] = { 'actions.select', opts = { tab = true } },
      ['<f4>'] = 'actions.preview',
      ['q'] = { 'actions.close', mode = 'n' },
      ['<f5>'] = 'actions.refresh',
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['gt'] = { 'actions.toggle_trash', mode = 'n' },
    },
  },
  keys = {
    { '-', '<cmd>Oil<CR>', desc = 'Oil' },
  },
}
