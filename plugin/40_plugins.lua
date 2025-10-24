local add, later = MiniDeps.add, MiniDeps.later
local now_if_args = _G.Config.now_if_args

now_if_args(function()
  add {
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd 'TSUpdate' end },
  }
  add {
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    checkout = 'main',
  }

  -- stylua: ignore
  local languages = {
    'html',       'css',  'go',       'python',
    'diff',       'bash', 'json',     'regex',
    'toml',       'yaml', 'markdown', 'javascript', 'clojure',
    'typescript', 'tsx',  'rust',     'lua',        'vimdoc', 'java'
  }

  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end

  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  _G.Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
end)

now_if_args(function()
  add 'neovim/nvim-lspconfig'

  vim.lsp.enable {
    'eslint',
    'gopls',
    'lua_ls',
    'pyright',
    'ruff',
    'ts_ls',
    'clojure_lsp',
    'jdtls',
  }
end)

later(function()
  add 'tpope/vim-fugitive'
  add 'tpope/vim-rhubarb'
end)

later(function()
  add 'stevearc/conform.nvim'

  vim.g.autoformat = true

  require('conform').setup {
    notify_on_error = false,
    notify_no_formatters = false,
    default_format_opts = {
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },
    formatters = {
      stylua = { require_cwd = true },
      prettier = { require_cwd = false },
      injected = { ignore_errors = true },
    },
    formatters_by_ft = {
      go = { 'gofumpt' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      less = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier', 'injected', timeout_ms = 1500 },
      css = { 'prettier' },
      clojure = { lsp_format = 'prefer', name = 'clojure_lsp' },
      scss = { 'prettier' },
      yaml = { 'prettier' },
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
    },
    format_on_save = function()
      if not vim.g.autoformat then return nil end
      return {}
    end,
  }

  local set = vim.keymap.set
  local function toggle_format() vim.g.autoformat = not vim.g.autoformat end
  set('n', [[\f]], toggle_format, { desc = "Toggle 'vim.g.autoformat'" })
end)

later(function() add 'Olical/conjure' end)
