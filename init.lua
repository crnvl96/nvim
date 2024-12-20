pcall(function() vim.loader.enable() end)

local path_source = vim.fn.stdpath('config') .. '/src/'
local cli_requirements = {
  'zathura', -- tex
  'tex-fmt', -- tex
  'tree-sitter',
  'rg',
  'npm', -- markdown-preview
  'rustc', -- blink.cmp (needs rustc nightly)
}

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

require('mini.deps').setup({ path = { package = path_package } })
local source = function(path) dofile(path_source .. path .. '.lua') end
local plugin = function(plugin) source('plugins/' .. plugin) end

Add, Now, Later = MiniDeps.add, MiniDeps.now, MiniDeps.later

--
-- General options
--

Now(function() source('opts') end)

Now(function()
  --
  -- Build functions
  --

  local function build_blink(params)
    vim.notify('Building blink.cmp', vim.log.levels.INFO)
    local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
    if obj.code == 0 then
      vim.notify('Building blink.cmp done', vim.log.levels.INFO)
    else
      vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
    end
  end

  local function build_mkdp(params)
    vim.notify('Building mkdp', vim.log.levels.INFO)
    local obj = vim.system({ 'cd', 'app', '&&', 'npm', 'install' }, { cwd = params.path }):wait()
    if obj.code == 0 then
      vim.notify('Building mkdp done', vim.log.levels.INFO)
    else
      vim.notify('Building mkdp failed', vim.log.levels.ERROR)
    end
  end

  --
  -- Plugin Definitions
  --

  Add({
    source = 'williamboman/mason.nvim',
    hooks = {
      post_checkout = function() vim.cmd('MasonUpdate') end,
    },
  })

  Add({
    source = 'Saghen/blink.cmp',
    depends = {
      { source = 'saghen/blink.compat' },
    },
    hooks = {
      post_install = build_blink,
      post_checkout = build_blink,
    },
  })

  Add({
    source = 'iamcco/markdown-preview.nvim',
    hooks = {
      post_install = build_mkdp,
      post_checkout = build_mkdp,
    },
  })

  Add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })

  Add({
    source = 'psliwka/vim-dirtytalk',
    hooks = {
      post_checkout = function() vim.cmd('DirtytalkUpdate') end,
    },
  })

  Add('folke/snacks.nvim')
  Add('nvim-lua/plenary.nvim')
  Add('nvim-treesitter/nvim-treesitter-textobjects')
  Add('stevearc/dressing.nvim')
  Add('saghen/blink.compat')
  Add('olimorris/codecompanion.nvim')
  Add('stevearc/conform.nvim')
  Add('HakonHarnes/img-clip.nvim')
  Add('neovim/nvim-lspconfig')
  Add('mfussenegger/nvim-dap-python')
  Add('theHamsta/nvim-dap-virtual-text')
  Add('mfussenegger/nvim-dap')
  Add('mfussenegger/nvim-lint')
  Add('lervag/vimtex')
  Add('mechatroner/rainbow_csv')
  Add('lambdalisue/vim-suda')
  Add('ficcdaf/academic.nvim')

  --
  -- Colorscheme
  --

  vim.cmd('colorscheme minicyan')
end)

--
-- Plugin settings
--

Now(function() plugin('mason') end)
Now(function() plugin('mini.icons') end)
Now(function() plugin('snacks') end)

Later(function() plugin('blink.cmp') end)
Later(function() plugin('codecompanion') end)
Later(function() plugin('conform') end)
Later(function() plugin('dressing') end)
Later(function() plugin('img-clip') end)
Later(function() plugin('markdown-preview') end)
Later(function() plugin('mini.ai') end)
Later(function() plugin('mini.basics') end)
Later(function() plugin('mini.bracketed') end)
Later(function() plugin('mini.bufremove') end)
Later(function() plugin('mini.clue') end)
Later(function() plugin('mini.diff') end)
Later(function() plugin('mini.doc') end)
Later(function() plugin('mini.extra') end)
Later(function() plugin('mini.files') end)
Later(function() plugin('mini.git') end)
Later(function() plugin('mini.hipatterns') end)
Later(function() plugin('mini.jump') end)
Later(function() plugin('mini.jump2d') end)
Later(function() plugin('mini.map') end)
Later(function() plugin('mini.misc') end)
Later(function() plugin('mini.move') end)
Later(function() plugin('mini.notify') end)
Later(function() plugin('mini.operators') end)
Later(function() plugin('mini.pairs') end)
Later(function() plugin('mini.pick') end)
Later(function() plugin('mini.snippets') end)
Later(function() plugin('mini.splitjoin') end)
Later(function() plugin('mini.visits') end)
Later(function() plugin('nvim-dap') end)
Later(function() plugin('nvim-lint') end)
Later(function() plugin('nvim-lspconfig') end)
Later(function() plugin('nvim-treesitter') end)
Later(function() plugin('vimtex') end)

--
-- Keymaps are sourced later on purpose
--

Later(function() source('keymaps') end)
