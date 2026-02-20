Config.later(function() vim.pack.add({ 'https://github.com/tpope/vim-fugitive' }) end)

Config.later(function()
  vim.pack.add({ 'https://github.com/salkhalil/summon.nvim' })

  require('summon').setup({
    width = 0.85,
    height = 0.85,
    border = 'single',
    close_keymap = '<C-g><C-g>',
    highlights = {
      float = { bg = '#282828' },
      border = { fg = '#d79921', bg = '#282828' },
      title = { fg = '#282828', bg = '#d79921', bold = true },
    },
    terminal_passthrough_keys = { '<C-o>', '<C-i>' },
    commands = {
      termA = {
        type = 'terminal',
        command = '/usr/bin/bash',
        title = ' Term A ',
        keymap = '<leader>ia',
      },
      termB = {
        type = 'terminal',
        command = '/usr/bin/bash',
        title = ' Term S ',
        keymap = '<leader>is',
      },
      opencode = {
        type = 'terminal',
        command = 'opencode',
        title = ' Opencode ',
        keymap = '<leader>io',
      },
    },
  })
end)

Config.later(function()
  vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })
  require('lualine').setup()
end)
