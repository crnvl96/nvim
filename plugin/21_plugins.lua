local add, later = MiniDeps.add, MiniDeps.later

later(function() add({ source = 'nvim-lua/plenary.nvim' }) end)
later(function() add({ source = 'lambdalisue/vim-suda' }) end)
later(function() add({ source = 'mechatroner/rainbow_csv' }) end)
later(function() add({ source = 'HakonHarnes/img-clip.nvim' }) end)
later(function() add({ source = 'mfussenegger/nvim-lint' }) end)
later(function() add({ source = 'lervag/vimtex' }) end)

later(function()
  add({
    source = 'iamcco/markdown-preview.nvim',
    hooks = {
      post_checkout = function()
        later(function() vim.fn['mkdp#util#install']() end)
      end,
      post_install = function()
        later(function() vim.fn['mkdp#util#install']() end)
      end,
    },
  })
end)

later(function()
  add({
    source = 'williamboman/mason.nvim',
    hooks = { post_checkout = function() vim.cmd('MasonUpdate') end },
  })

  require('mason').setup()
  later(Lang.refresh_mason_registry)
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })

  require('nvim-treesitter.configs').setup(Plugin.treesitter_opts())
end)

later(function()
  add({ source = 'saghen/blink.compat' })
  add({
    source = 'Saghen/blink.cmp',
    hooks = {
      post_checkout = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
      post_install = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
    },
  })

  require('blink.compat').setup()
  require('blink.cmp').setup(Plugin.blink_opts())
end)

later(function()
  add({ source = 'olimorris/codecompanion.nvim' })
  require('codecompanion').setup(Plugin.codecompanion_opts())
end)

later(function()
  add({ source = 'stevearc/conform.nvim' })
  require('conform').setup(Plugin.conform_opts())
end)

later(function()
  add({ source = 'neovim/nvim-lspconfig' })
  Lang.setup_lsp_servers()
end)

later(function()
  add({ source = 'mfussenegger/nvim-dap-python' })
  add({ source = 'theHamsta/nvim-dap-virtual-text' })
  add({ source = 'mfussenegger/nvim-dap' })

  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
  require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })
  require('dap.ext.vscode').json_decode = Config.json_decode

  Lang.setup_lang_servers()
end)
