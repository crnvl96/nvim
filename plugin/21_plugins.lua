Later(function() Add({ source = 'nvim-lua/plenary.nvim' }) end)
Later(function() Add({ source = 'lambdalisue/vim-suda' }) end)
Later(function() Add({ source = 'ficcdaf/academic.nvim' }) end)
Later(function() Add({ source = 'mechatroner/rainbow_csv' }) end)
Later(function() Add({ source = 'HakonHarnes/img-clip.nvim' }) end)
Later(function() Add({ source = 'mfussenegger/nvim-lint' }) end)
Later(function() Add({ source = 'lervag/vimtex' }) end)

Later(function()
  Add({
    source = 'psliwka/vim-dirtytalk',
    hooks = {
      post_checkout = function() vim.cmd('DirtytalkUpdate') end,
    },
  })
end)

Later(function()
  Add({
    source = 'iamcco/markdown-preview.nvim',
    hooks = {
      post_checkout = function()
        Later(function() vim.fn['mkdp#util#install']() end)
      end,
      post_install = function()
        Later(function() vim.fn['mkdp#util#install']() end)
      end,
    },
  })
end)

Later(function()
  Add({
    source = 'williamboman/mason.nvim',
    hooks = { post_checkout = function() vim.cmd('MasonUpdate') end },
  })

  require('mason').setup()
  Later(RefreshMasonRegistry)
end)

Later(function()
  Add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })

  require('nvim-treesitter.configs').setup({
    highlight = {
      enable = true,
      disable = function(_, buf) return vim.tbl_contains({ 'tex', 'bigfile' }, vim.bo[buf].filetype) end,
    },
    indent = {
      enable = true,
    },
    sync_install = false,
    auto_install = true,
    ensure_installed = {
      'c',
      'vim',
      'vimdoc',
      'query',
      'markdown',
      'markdown_inline',

      -- lua
      'lua',

      -- js/ts
      'javascript',
      'typescript',
      'tsx',

      -- python
      'python',
    },
  })
end)

Later(function()
  Add({ source = 'saghen/blink.compat' })
  Add({
    source = 'Saghen/blink.cmp',
    hooks = {
      post_checkout = function(params) DepsBuild(params, { 'cargo', 'build', '--release' }) end,
      post_install = function(params) DepsBuild(params, { 'cargo', 'build', '--release' }) end,
    },
  })

  require('blink.compat').setup()
  require('blink.cmp').setup({
    enabled = function()
      return not vim.tbl_contains({ 'minifiles', 'markdown' }, vim.bo.filetype)
        and vim.bo.buftype ~= 'prompt'
        and vim.b.completion ~= false
    end,
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono',
    },
    keymap = {
      preset = 'default',
      ['<C-n>'] = { 'select_next' },
      ['<C-p>'] = { 'select_prev' },
      ['<Tab>'] = { 'select_next' },
      ['<S-Tab>'] = { 'select_prev' },
      cmdline = {
        ['<C-n>'] = { 'show', 'select_next' },
        ['<C-p>'] = { 'select_prev' },
        ['<Tab>'] = { 'select_next' },
        ['<S-Tab>'] = { 'select_prev' },
      },
    },
    completion = {
      ghost_text = { enabled = true },
      trigger = { show_on_insert_on_trigger_character = false },
      keyword = { range = 'full' },
      accept = { auto_brackets = { enabled = false } },
      list = { selection = function(ctx) return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect' end },
      menu = {
        border = 'single',
        scrollbar = false,
        draw = {
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = {
          border = 'single',
          scrollbar = false,
        },
      },
    },
    sources = {
      default = { 'lsp', 'path', 'buffer' },
      per_filetype = {
        codecompanion = { 'codecompanion', 'path' },
      },
      providers = {
        codecompanion = {
          name = 'CodeCompanion',
          module = 'codecompanion.providers.completion.blink',
          enabled = true,
        },
      },
    },
    signature = {
      enabled = true,
      window = { border = 'single' },
    },
  })
end)

Later(function()
  Add({ source = 'olimorris/codecompanion.nvim' })

  local path = vim.fn.stdpath('config') .. '/anthropic'
  local file = io.open(path, 'r')
  local key

  if file then
    key = file:read('*a'):gsub('%s+$', '')
    file:close()
  end

  require('codecompanion').setup({
    strategies = {
      chat = { adapter = 'anthropic' },
      inline = { adapter = 'anthropic' },
      cmd = { adapter = 'anthropic' },
    },
    adapters = {
      anthropic = require('codecompanion.adapters').extend('anthropic', {
        env = { api_key = key },
        schema = {
          model = {
            default = 'claude-3-5-haiku-20241022',
          },
        },
      }),
    },
  })
end)

Later(function()
  Add({ source = 'stevearc/conform.nvim' })

  require('conform').setup({
    notify_on_error = true,
    formatters_by_ft = {
      markdown = { 'prettierd', 'injected' },
      css = { 'prettierd' },
      tex = { 'tex-fmt' },
      html = { 'prettierd' },
      json = { 'prettierd' },
      toml = { 'taplo' },
      lua = { 'stylua' },
      javascript = { 'deno_fmt', 'prettierd' },
      typescript = { 'deno_fmt', 'prettierd' },
      javascriptreact = { 'deno_fmt', 'prettierd' },
      typescriptreact = { 'deno_fmt', 'prettierd' },
      ['javascript.tsx'] = { 'deno_fmt', 'prettierd' },
      ['typescript.tsx'] = { 'deno_fmt', 'prettierd' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
    },
    format_on_save = function()
      return {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = 'fallback',
      }
    end,
    formatters = {
      injected = { ignore_errors = true },
      prettierd = {
        condition = function()
          local buffer = vim.api.nvim_get_current_buf()
          return (
            vim.tbl_contains({
              'javascript',
              'javascriptreact',
              'javascript.jsx',
              'typescript',
              'typescriptreact',
              'typescript.tsx',
            }, vim.bo[buffer].filetype) and not vim.fs.root(buffer, { 'package.json' })
          ) or true
        end,
      },
      deno_fmt = {
        condition = function()
          return vim.fs.root(vim.api.nvim_get_current_buf(), { 'deno.json', 'deno.jsonc' }) and true or false
        end,
      },
    },
  })
end)

Later(function()
  Add({ source = 'neovim/nvim-lspconfig' })

  require('lspconfig').vtsls.setup({
    capabilities = Capabilities(),
    root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'package.json' }) end,
    single_file_support = false, -- avoid setting up vtsls on deno projects
  })

  require('lspconfig').denols.setup({
    capabilities = Capabilities(),
    root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'deno.json', 'deno.jsonc' }) end,
  })

  require('lspconfig').basedpyright.setup({
    capabilities = Capabilities(),
    settings = {
      basedpyright = {
        typeCheckingMode = 'basic', -- Options: "off", "basic", "strict"
      },
    },
  })

  require('lspconfig').lua_ls.setup({
    capabilities = Capabilities(),
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        codeLens = { enable = true },
        doc = { privateName = { '^_' } },
      },
    },
  })
end)

Later(function()
  Add({ source = 'mfussenegger/nvim-dap-python' })
  Add({ source = 'theHamsta/nvim-dap-virtual-text' })
  Add({ source = 'mfussenegger/nvim-dap' })

  local function json_decode(data)
    local decode = vim.json.decode
    local strip_comments = require('plenary.json').json_strip_comments
    data = strip_comments(data)

    return decode(data)
  end

  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

  require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })
  require('dap-python').setup(require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python')
  require('dap.ext.vscode').json_decode = json_decode
end)
