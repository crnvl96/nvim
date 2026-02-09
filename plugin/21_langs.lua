MiniDeps.now(function()
  MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })

  MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    checkout = 'main',
  })

  local treesit_langs = {
    -- note: parsers for c, lua, vim, vimdoc, query and markdown are already included in neovim
    'bash',
    'css',
    'diff',
    'go',
    'html',
    'javascript',
    'json',
    'python',
    'regex',
    'typst',
    'toml',
    'tsx',
    'typescript',
    'yaml',
    'javascript',
    'typescript',
  }

  require('nvim-treesitter').install(
    vim
      .iter(treesit_langs)
      :filter(function(item) return #vim.api.nvim_get_runtime_file('parser/' .. item .. '.*', false) == 0 end)
      :flatten()
      :totable()
  )

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('crnvl96-nvim-treesitter', {}),
    pattern = vim
      .iter(treesit_langs)
      :map(function(item) return vim.treesitter.language.get_filetypes(item) end)
      :flatten()
      :totable(),
    callback = function(ev) vim.treesitter.start(ev.buf) end,
  })
end)

MiniDeps.now(function()
  MiniDeps.add('neovim/nvim-lspconfig')
  vim.lsp.enable({
    'lua_ls',
    'pyright',
    'ruff',
    'ts_ls',
    'biome',
    'eslint',
    'clangd',
    'tinymist',
  })
end)

MiniDeps.later(function()
  MiniDeps.add('stevearc/conform.nvim')

  local conf = require('conform')
  local util = require('conform.util')

  local fmt = {
    web = function()
      if util.root_file({ 'biome.json', 'biome.jsonc' }) then
        return { 'biome' }
      else
        return { 'prettier' }
      end
    end,
    prettier = function() return { 'prettier' } end,
    python = function() return { 'rufff_organize_imports', 'ruff_fix', 'ruff_format' } end,
    c = function() return { 'clang-format' } end,
    typst = function() return { 'typstyle' } end,
    lua = function() return { 'stylua' } end,
    default = function() return { 'trim_whitespace', 'trim_newline' } end,
  }

  vim.g.autoformat = true

  conf.setup({
    notify_on_error = false,
    notify_no_formatters = false,
    default_format_opts = {
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },
    formatters = {
      stylua = { require_cwd = true },
      prettier = { require_cwd = false },
    },
    format_on_save = function()
      if not vim.g.autoformat then return nil end
      return {}
    end,
    formatters_by_ft = {
      ['_'] = fmt.default,
      c = fmt.c,
      javascript = fmt.web,
      typescript = fmt.web,
      python = fmt.python,
      lua = fmt.lua,
      json = fmt.prettier,
      jsonc = fmt.prettier,
      yaml = fmt.prettier,
      markdown = fmt.prettier,
    },
  })

  vim.keymap.set('n', [[\f]], function() vim.g.autoformat = not vim.g.autoformat end)
end)
