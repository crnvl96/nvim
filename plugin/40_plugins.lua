Config.now_if_args(function() require('crnvl.plug._schemastore') end)
Config.now_if_args(function() require('crnvl.plug._sleuth') end)
Config.now_if_args(function() require('crnvl.plug._ts-autotag') end)
Config.now_if_args(function() require('crnvl.plug._ts-comments') end)

Config.now_if_args(function() require('crnvl.plug._image') end)
Config.now_if_args(function() require('crnvl.plug._img-clip') end)
Config.now_if_args(function() require('crnvl.plug._markdown-preview') end)
Config.now_if_args(function() require('crnvl.plug._typst-preview') end)

Config.now_if_args(function() require('crnvl.plug._conform') end)
Config.now_if_args(function() require('crnvl.plug._lspconfig') end)
Config.now_if_args(function() require('crnvl.plug._treesitter') end)

Config.now_if_args(function() require('crnvl.plug._mini-ai') end)
Config.now_if_args(function() require('crnvl.plug._mini-align') end)
Config.now_if_args(function() require('crnvl.plug._mini-bufremove') end)
Config.now_if_args(function() require('crnvl.plug._mini-clue') end)
Config.now_if_args(function() require('crnvl.plug._mini-cmdline') end)
Config.now_if_args(function() require('crnvl.plug._mini-completion') end)
Config.now_if_args(function() require('crnvl.plug._mini-files') end)
Config.now_if_args(function() require('crnvl.plug._mini-hipatterns') end)
Config.now_if_args(function() require('crnvl.plug._mini-indentscope') end)
Config.now_if_args(function() require('crnvl.plug._mini-jump2d') end)
Config.now_if_args(function() require('crnvl.plug._mini-keymap') end)
Config.now_if_args(function() require('crnvl.plug._mini-move') end)
Config.now_if_args(function() require('crnvl.plug._mini-operators') end)
Config.now_if_args(function() require('crnvl.plug._mini-pairs') end)
Config.now_if_args(function() require('crnvl.plug._mini-pick') end)
Config.now_if_args(function() require('crnvl.plug._mini-snippets') end)
Config.now_if_args(function() require('crnvl.plug._mini-splitjoin') end)
Config.now_if_args(function() require('crnvl.plug._mini-surround') end)

-- Organize this later

Config.now_if_args(function() require('mini.statusline').setup() end)

Config.now_if_args(function()
  require('mini.bracketed').setup({
    indent = { suffix = '', options = {} },
  })

  vim.keymap.set(
    'n',
    '<Leader>xH',
    "<Cmd>lua MiniBracketed.quickfix('first')<CR>"
  )
  vim.keymap.set(
    'n',
    '<Leader>xh',
    "<Cmd>lua MiniBracketed.quickfix('backward')<CR>"
  )
  vim.keymap.set(
    'n',
    '<Leader>xl',
    "<Cmd>lua MiniBracketed.quickfix('forward')<CR>"
  )
  vim.keymap.set(
    'n',
    '<Leader>xL',
    "<Cmd>lua MiniBracketed.quickfix('last')<CR>"
  )
end)

Config.now_if_args(function()
  require('mini.diff').setup({
    view = { style = 'sign' },
  })

  vim.keymap.set(
    'n',
    '<Leader>go',
    function() MiniDiff.toggle_overlay() end,
    { desc = 'Toggle git overlay' }
  )

  vim.keymap.set('n', '<Leader>ge', function()
    vim.fn.setqflist(MiniDiff.export('qf'))
    vim.cmd('copen')
  end, { desc = 'Export to Quickfix' })
end)

Config.now_if_args(function()
  require('mini.git').setup()

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniGitCommandSplit',
    group = Config.gr,
    callback = function(e)
      if e.data.git_subcommand ~= 'status' then return end
      vim.api.nvim_set_option_value(
        'filetype',
        'gitstatus',
        { scope = 'local', buf = vim.api.nvim_win_get_buf(e.data.win_stdout) }
      )
    end,
  })

  vim.keymap.set(
    'n',
    '<Leader>gs',
    '<Cmd>Git status<CR>',
    { desc = 'Git status' }
  )

  vim.keymap.set(
    'n',
    '<Leader>gc',
    '<Cmd>Git commit<CR>',
    { desc = 'Git commit' }
  )
end)
