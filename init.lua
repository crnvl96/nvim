pcall(function() vim.loader.enable() end)

local path_source = vim.fn.stdpath('config') .. '/src/'
local cli_requirements = { 'zathura', 'tex-fmt', 'tree-sitter', 'rg', 'npm', 'rustc' }

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

for _, cli in ipairs(cli_requirements) do
  if vim.fn.executable(cli) ~= 1 then
    vim.notify(cli .. ' is not installed in the system.', vim.log.levels.ERROR)
    return
  end
end

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })
local source = function(path) dofile(path_source .. path) end

_G.Config = {}

Add, Now, Later = MiniDeps.add, MiniDeps.now, MiniDeps.later

Later(function() Add({ name = 'mini.nvim', checkout = 'HEAD' }) end)
Later(function() vim.cmd('colorscheme minicolors') end)
Later(function() source('opts.lua') end)

Later(function() source('plugins/miniicons.lua') end)
Later(function() source('plugins/mininotify.lua') end)
Later(function() source('plugins/minimisc.lua') end)

Later(function() source('plugins/mason.lua') end)
Later(function() source('plugins/treesitter.lua') end)

Later(function() Add('nvim-treesitter/nvim-treesitter-textobjects') end)
Later(function() Add('nvim-lua/plenary.nvim') end)
Later(function() Add('mechatroner/rainbow_csv') end)

Later(function() require('mini.extra').setup() end)
Later(function() require('mini.splitjoin').setup() end)
Later(function() require('mini.bracketed').setup() end)
Later(function() require('mini.doc').setup() end)
Later(function() require('mini.move').setup() end)
Later(function() require('mini.jump').setup() end)
Later(function() require('mini.git').setup() end)
Later(function() require('mini.bufremove').setup() end)
Later(function() require('mini.diff').setup({ view = { style = 'sign' } }) end)
Later(function() require('mini.visits').setup() end)
Later(function() require('mini.operators').setup() end)
Later(function()
  Add('stevearc/dressing.nvim')
  require('dressing').setup()
end)

Later(function() source('plugins/blink.lua') end)
Later(function() source('plugins/codecompanion.lua') end)
Later(function() source('plugins/conform.lua') end)
Later(function() source('plugins/img-clip.lua') end)
Later(function() source('plugins/lsp.lua') end)
Later(function() source('plugins/markdown-preview.lua') end)
Later(function() source('plugins/miniai.lua') end)
Later(function() source('plugins/minibasics.lua') end)
Later(function() source('plugins/minihipatterns.lua') end)
Later(function() source('plugins/minijump2d.lua') end)
Later(function() source('plugins/minipick.lua') end)
Later(function() source('plugins/dap.lua') end)
Later(function() source('plugins/lint.lua') end)
Later(function() source('plugins/minifiles.lua') end)
Later(function() source('plugins/vimtex.lua') end)
Later(function() source('plugins/minimap.lua') end)
Later(function() source('plugins/miniclue.lua') end)

Later(function() source('keymaps.lua') end)
