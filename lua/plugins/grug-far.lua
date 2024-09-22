return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  opts = {},
  config = function(_, opts)
    local grug = require('grug-far')
    grug.setup(opts)

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup(vim.g.whoami .. '/grug_group', {}),
      pattern = { 'grug-far' },
      callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
    })
  end,
  keys = function()
    local grug = require('grug-far')

    return {
      {
        '<leader>cr',
        function()
          local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
              keymaps = { help = '?' },
            },
          })
        end,
        mode = { 'n', 'v' },
        desc = 'Search and Replace',
      },
      {
        '<leader>c%',
        function()
          local cur = vim.bo.buftype == '' and vim.fn.expand('%')
          grug.open({
            transient = true,
            prefills = {
              filesFilter = cur ~= '' and cur or nil,
              keymaps = { help = '?' },
            },
          })
        end,
        mode = { 'n', 'v' },
        desc = 'Search in local buffer',
      },
    }
  end,
}
