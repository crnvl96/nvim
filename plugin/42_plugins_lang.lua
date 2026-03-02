Config.now_if_args(function()
  Config.on_packchanged('nvim-treesitter', { 'update' }, function(e)
    MiniMisc.log_add('Updating parsers', { name = e.data.spec.name, path = e.data.path })
    vim.cmd('TSUpdate')
    MiniMisc.log_add('Parsers updates', { name = e.data.spec.name, path = e.data.path })
  end)

  vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  -- stylua: ignore
  local treesit_langs = {
    -- NOTE: parsers for c, lua, vim, vimdoc, query and markdown are already included in neovim
    'bash',      'c',   'css',      'diff',   'dockerfile', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit',
    'gitignore', 'go',  'gomod',    'gosum',  'gowork',     'html',       'javascript', 'json',          'json5',
    'jsx',       'lua', 'markdown', 'python', 'regex',      'ruby',       'toml',       'tsx',           'typescript',
    'typst',     'vim', 'vimdoc',   'yaml',   'jsdoc'
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

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

  -- stylua: ignore
  vim.lsp.enable({
    'biome',  'eslint',  'gopls',    'lua_ls', 'oxfmt',
    'oxlint', 'rubocop', 'ruby_lsp', 'ruff',   'tinymist',
    'tsgo',   'ty',      'jsonls',   'yamlls',
    -- 'harper_ls', 'pyright',
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = Config.gr,
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end
      --
      -- Gopls extra config
      --
      if client.name == 'gopls' then
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        if not client.server_capabilities.semanticTokensProvider then
          local semantic = client.config.capabilities.textDocument.semanticTokens
          if not semantic then return end
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = { tokenTypes = semantic.tokenTypes, tokenModifiers = semantic.tokenModifiers },
            range = true,
          }
        end
      end
    end,
  })

  Config.set_keymap('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>')
  Config.set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  Config.set_keymap('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')

  Config.set_keymap('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'Code actions')
  Config.set_keymap('n', '<Leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', 'Rename')
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

  local autoformat = true

  require('conform').setup({
    notify_on_error = false,
    notify_no_formatters = false,
    default_format_opts = {
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },
    formatters = {
      stylua = {
        require_cwd = true,
      },
      prettier = {
        require_cwd = false,
      },
    },
    format_on_save = function()
      if not autoformat then return nil end
      return {}
    end,
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace', 'trim_newline' },
      javascript = { 'prettier', lsp_format = 'prefer', timeout_ms = 1000 },
      typescript = { 'prettier', lsp_format = 'prefer', timeout_ms = 1000 },
      javascriptreact = { 'prettier', lsp_format = 'prefer', timeout_ms = 1000 },
      typescriptreact = { 'prettier', lsp_format = 'prefer', timeout_ms = 1000 },
      typst = { 'typstyle', lsp_format = 'prefer' },
      go = { lsp_format = 'prefer' },
      python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
      lua = { 'stylua' },
      json = { 'prettier' },
      css = { 'prettier' },
      jsonc = { 'prettier' },
      json5 = { 'prettier' },
      ruby = { 'rubocop' },
      yaml = { 'prettier' },
      markdown = { 'prettier', 'injected' },
    },
  })

  local toggle_autoformat = function() autoformat = not autoformat end
  Config.set_keymap('n', '<Leader>uf', toggle_autoformat, 'Toggle autoformat')
  Config.set_keymap('n', '<Leader>ur', '<Cmd>lua MiniMisc.put(MiniMisc.find_root())<CR>', 'Find current root')
end)
