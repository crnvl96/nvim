return {
  'stevearc/quicker.nvim',
  ft = 'qf',
  opts = {},
  keys = {
    { '<leader>xx', function() require('quicker').toggle() end, desc = 'Toggle quickfix' },
    {
      '<leader>xd',
      function()
        local quicker = require('quicker')

        if quicker.is_open() then
          quicker.close()
        else
          vim.diagnostic.setqflist()
        end
      end,
      desc = 'Toggle diagnostics',
    },
    {
      '>',
      function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end,
      desc = 'Expand context',
    },
    {
      '<',
      function() require('quicker').collapse() end,
      desc = 'Collapse context',
    },
  },
}
