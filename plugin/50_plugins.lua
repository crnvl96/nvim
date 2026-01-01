local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function() add 'tpope/vim-fugitive' end)

now(function()
  add {
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd 'TSUpdate' end },
  }

  add { source = 'nvim-treesitter/nvim-treesitter-textobjects', checkout = 'main' }

  -- stylua: ignore
  local languages = {
    'bash', 'css', 'diff', 'html', 'javascript',
    'json', 'lisp', 'lua', 'markdown', 'python',
    'regex', 'toml', 'tsx', 'typescript', 'vimdoc',
    'yaml',
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

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('crnvl96-nvim-treesitter', {}),
    pattern = filetypes,
    callback = function(ev) vim.treesitter.start(ev.buf) end,
  })
end)

now(function()
  add 'neovim/nvim-lspconfig'

  vim.lsp.enable {
    'eslint',
    'lua_ls',
    'pyright',
    'ruff',
    'ts_ls',
  }
end)

later(function()
  add 'MagicDuck/grug-far.nvim'

  require('grug-far').setup()
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
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier', 'injected', timeout_ms = 1500 },
      css = { 'prettier' },
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
