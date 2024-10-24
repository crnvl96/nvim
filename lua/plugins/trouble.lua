return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {
    modes = {
      lsp = {
        win = { position = 'bottom' },
      },
    },
  },
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
    { '<leader>cs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols (Trouble)' },
    { '<leader>cl', '<cmd>Trouble lsp toggle<cr>', desc = 'LSP references/definitions/... (Trouble)' },
    {
      '[q',
      function()
        if require('trouble').is_open() then
          require('trouble').prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then vim.notify(err, vim.log.levels.ERROR) end
        end
      end,
      desc = 'Previous Trouble/Quickfix Item',
    },
    {
      ']q',
      function()
        if require('trouble').is_open() then
          require('trouble').next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then vim.notify(err, vim.log.levels.ERROR) end
        end
      end,
      desc = 'Next Trouble/Quickfix Item',
    },
  },
}
