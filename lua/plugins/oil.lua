return {
  'stevearc/oil.nvim',
  opts = function()
    local detail = false

    return {
      watch_for_changes = true,
      view_options = { show_hidden = false },
      keymaps = {
        ['<C-v>'] = false,
        ['<C-s>'] = false,
        ['<C-t>'] = false,
        ['<C-p>'] = false,
        ['<C-l>'] = false,

        ['gd'] = {
          desc = 'Toggle file detail view',
          callback = function()
            detail = not detail
            if detail then
              require('oil').set_columns({ 'icon', 'permissions', 'size', 'mtime' })
            else
              require('oil').set_columns({ 'icon' })
            end
          end,
        },

        ['<c-w>v'] = { 'actions.select', opts = { vertical = true } },
        ['<c-w>s'] = { 'actions.select', opts = { horizontal = true } },
        ['<c-w>t'] = { 'actions.select', opts = { tab = true } },
        ['<f4>'] = 'actions.preview',
        ['<f5>'] = 'actions.refresh',
      },
    }
  end,
  keys = {
    { '-', '<cmd>Oil<CR>' },
  },
}
