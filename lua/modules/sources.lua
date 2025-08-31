local U = require('utils')

--- Helper for mini.deps helper that wraps common operations on plugins that require a build step.
---@param params table Params for building the plugin
---@param cmd string Cmd to run then building the plugin
---@return nil
local function build(params, cmd)
  local name, path = params.name, params.path
  local msg = ('Building %s'):format(name)
  U.publish(msg .. '...')
  local out = vim.system(vim.split(cmd, ' '), { cwd = path }):wait()

  if out.code == 0 then
    return U.publish(msg .. ' done!')
  else
    return U.publish(msg .. ' failed', 'ERROR')
  end
end

MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'main',
  hooks = {
    post_checkout = function() vim.cmd('TSUpdate') end,
  },
})

MiniDeps.add({
  source = 'Saghen/blink.cmp',
  checkout = 'v1.6.0',
  monitor = 'main',
})

MiniDeps.add({
  source = 'dmtrKovalenko/fff.nvim',
  hooks = {
    post_install = function(params) build(params, 'cargo +nightly build --release') end,
    post_checkout = function(params) build(params, 'cargo +nightly build --release') end,
  },
})

MiniDeps.add({
  source = 'mrcjkb/rustaceanvim',
  version = 'v6.9.1',
  monitor = 'master',
})

MiniDeps.add({ source = 'b0o/SchemaStore.nvim' })
MiniDeps.add({ source = 'nvim-lua/plenary.nvim' })
MiniDeps.add({ source = 'olimorris/codecompanion.nvim' })
MiniDeps.add({ source = 'stevearc/conform.nvim' })
MiniDeps.add({ source = 'Saecki/crates.nvim' })
MiniDeps.add({ source = 'MagicDuck/grug-far.nvim' })
MiniDeps.add({ source = 'tpope/vim-sleuth' })
MiniDeps.add({ source = 'brianhuster/unnest.nvim' })
