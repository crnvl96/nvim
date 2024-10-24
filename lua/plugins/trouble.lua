return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = function()
    -- display previews as non-intrusive floating-windows
    local function default_preview()
      return {
        type = 'float',
        relative = 'editor',
        border = 'double',
        title = '', -- No title
        position = { 0, 0 },
        size = { width = 0.5, height = 0.8 },
        zindex = 200,
      }
    end

    return {
      modes = {
        diagnostics = {
          auto_open = false,
          auto_close = true,
          preview = default_preview(),
        },
        lsp = {
          auto_close = false,
          follow = false,
          win = { position = 'right', size = { width = 0.4 } },
          params = { include_current = true },
          preview = default_preview(),
        },
        symbols = {
          win = { position = 'right', size = { width = 0.4 } },
          preview = default_preview(),
        },
      },
    }
  end,
  keys = {
    { '<leader>cs', '<cmd>Trouble symbols toggle<cr>', desc = 'symbols' },
    { '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'bdiagnostics' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle<cr>', desc = 'diagnostics' },
    { '<leader>ll', '<cmd>Trouble lsp toggle<cr>', desc = 'lsp filter' },
  },
}
