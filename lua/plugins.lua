MiniDeps.now(function()
  MiniDeps.add { name = 'mini.nvim' }
  MiniDeps.add 'nvim-lua/plenary.nvim'

  vim.keymap.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>')
  vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>')
  vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>')
  vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>')

  require('mini.icons').setup()
  require('mini.icons').mock_nvim_web_devicons()

  MiniDeps.add 'neovim/nvim-lspconfig'
  MiniDeps.add 'tpope/vim-fugitive'
  MiniDeps.add 'tpope/vim-rhubarb'
  MiniDeps.add 'tpope/vim-sleuth'
  MiniDeps.add 'mbbill/undotree'
  MiniDeps.add 'christoomey/vim-tmux-navigator'
end)

MiniDeps.now(function()
  MiniDeps.add {
    source = 'mason-org/mason.nvim',
    hooks = { post_checkout = function() vim.cmd 'MasonUpdate' end },
  }

  local ensure_installed = {
    'stylua',
    'prettier',
    'ruff',
    'css-lsp',
    'eslint-lsp',
    'basedpyright',
    'lua-language-server',
    'vtsls',
    'biome',
    'typescript-language-server',
    'pyrefly',
    'pyright',
  }

  require('mason').setup()

  MiniDeps.later(function()
    local mr = require 'mason-registry'

    mr.refresh(function()
      for _, tool in ipairs(ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)

MiniDeps.now(function()
  MiniDeps.add {
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd 'TSUpdate' end },
  }

  local parsers = {
    'c',
    'lua',
    'prisma',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'markdown_inline',
    'javascript',
    'typescript',
    'tsx',
    'ruby',
    'python',
  }

  require('nvim-treesitter').install(parsers)

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('crnvl96-treesitter', {}),
    pattern = vim.tbl_deep_extend('force', parsers, { 'codecompanion' }),
    callback = function() vim.treesitter.start() end,
  })
end)

require 'plugins.blink'
require 'plugins.dap'
require 'plugins.fzf-lua'
require 'plugins.mini-files'
require 'plugins.ai'
require 'plugins.conform'
require 'plugins.lint'
