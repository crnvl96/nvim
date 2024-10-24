return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  opts = {
    options = {
      show_close_icon = false,
      show_buffer_close_icons = false,
      truncate_names = false,
      close_command = function(n) Snacks.bufdelete(n) end,
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
      diagnostics = 'nvim_lsp',
      always_show_bufferline = true,
      diagnostics_indicator = function(_, _, diag)
        local icons = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
        local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
          .. (diag.warning and icons.Warn .. diag.warning or '')
        return vim.trim(ret)
      end,
    },
  },
  keys = {
    { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
    { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
    { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
    { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
    { '<', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { '>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
    { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
  },
}
