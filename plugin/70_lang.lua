Config.later(function()
  Config.on_packchanged('nvim-treesitter', { 'update' }, function(e)
    MiniMisc.log_add('Updating parsers', {
      name = e.data.spec.name,
      path = e.data.path,
    })
    vim.cmd('TSUpdate')
    MiniMisc.log_add('Parsers updates', { name = e.data.spec.name, path = e.data.path })
  end)

  vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  -- stylua: ignore
  local treesit_langs = {
    -- note: parsers for c, lua, vim, vimdoc, query and markdown are already included in neovim
    'bash', 'css', 'diff', 'go', 'html',
    'javascript', 'jsx', 'json', 'python', 'regex',
    'toml', 'typescript', 'tsx', 'typst', 'yaml',
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

Config.later(function()
  vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })
  -- stylua: ignore
  vim.lsp.enable({
    'lua_ls', 'pyright', 'ruff', 'biome',
    'eslint', 'clangd', 'tinymist', 'ts_ls',
    -- 'tsgo',
  })
end)

Config.later(function()
  vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })
  local conform_autoformat = true
  require('conform').setup({
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
      if not conform_autoformat then return nil end
      return {}
    end,
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace', 'trim_newline' },
      c = { 'clang-format' },
      javascript = function()
        if require('conform.util').root_file({ 'biome.json', 'biome.jsonc' }) then
          return { 'biome' }
        else
          return { 'prettier' }
        end
      end,
      typescript = function()
        if require('conform.util').root_file({ 'biome.json', 'biome.jsonc' }) then
          return { 'biome' }
        else
          return { 'prettier' }
        end
      end,
      python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
      lua = { 'stylua' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      typst = { 'typstyle' },
      yaml = { 'prettier' },
      markdown = { 'prettier', 'injected' },
    },
  })
  -- stylua: ignore
  vim.keymap.set('n', [[\f]], function() conform_autoformat = not conform_autoformat end, { desc = 'Toggle autoformat' })
end)
