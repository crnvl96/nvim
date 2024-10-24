return {
  'nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile', 'VeryLazy' },
  opts = function()
    local tsc = require('treesitter-context')

    Snacks.toggle({
      name = 'Treesitter Context',
      get = tsc.enabled,
      set = function(state)
        if state then
          tsc.enable()
        else
          tsc.disable()
        end
      end,
    }):map('<leader>ut')

    return {
      mode = 'cursor',
      max_lines = 1,
    }
  end,
  keys = {
    {
      ']t',
      function()
        if vim.wo.diff then
          return '[c'
        else
          vim.schedule(function() require('treesitter-context').go_to_context() end)
          return '<Ignore>'
        end
      end,
      desc = 'Jump to upper context',
      expr = true,
    },
  },
}
