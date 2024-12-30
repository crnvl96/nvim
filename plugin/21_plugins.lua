local add, later = MiniDeps.add, MiniDeps.later

later(function() add({ source = 'nvim-lua/plenary.nvim' }) end)
later(function() add({ source = 'lambdalisue/vim-suda' }) end)
later(function() add({ source = 'mechatroner/rainbow_csv' }) end)
later(function() add({ source = 'HakonHarnes/img-clip.nvim' }) end)
later(function() add({ source = 'mfussenegger/nvim-lint' }) end)
later(function() add({ source = 'lervag/vimtex' }) end)

later(function()
  add({
    source = 'iamcco/markdown-preview.nvim',
    hooks = {
      post_checkout = function()
        later(function() vim.fn['mkdp#util#install']() end)
      end,
      post_install = function()
        later(function() vim.fn['mkdp#util#install']() end)
      end,
    },
  })
end)

later(function()
  add({
    source = 'williamboman/mason.nvim',
    hooks = { post_checkout = function() vim.cmd('MasonUpdate') end },
  })

  require('mason').setup()
  later(Config.refresh_registry)
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })

  require('nvim-treesitter.configs').setup({
    highlight = {
      enable = true,
      disable = function(_, buf) return vim.tbl_contains({ 'tex' }, vim.bo[buf].filetype) end,
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

later(function()
  add({ source = 'saghen/blink.compat' })
  add({
    source = 'Saghen/blink.cmp',
    hooks = {
      post_checkout = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
      post_install = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
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
      ghost_text = { enabled = false },
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

later(function()
  add({ source = 'olimorris/codecompanion.nvim' })

  local key = Config.retrieve_llm_key()
  if not key then
    vim.notify('An `anthropic` key must be set for a proper config setup', vim.log.levels.ERROR)
    return
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

later(function()
  add({ source = 'stevearc/conform.nvim' })

  local formatters_by_ft = Config.formatters_by_ft()
  local formatters = Config.formatters_settings()

  require('conform').setup({
    notify_on_error = true,
    formatters_by_ft = formatters_by_ft,
    formatters = formatters,
  })
end)

later(function()
  add({ source = 'neovim/nvim-lspconfig' })

  local capabilities = Config.capabilities()

  require('lspconfig').vtsls.setup({
    capabilities = capabilities,
    root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'package.json' }) end,
    single_file_support = false, -- avoid setting up vtsls on deno projects
  })

  require('lspconfig').denols.setup({
    capabilities = capabilities,
    root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'deno.json', 'deno.jsonc' }) end,
  })

  require('lspconfig').basedpyright.setup({
    capabilities = capabilities,
    settings = {
      basedpyright = {
        typeCheckingMode = 'basic', -- Options: "off", "basic", "strict"
      },
    },
  })

  require('lspconfig').lua_ls.setup({
    capabilities = capabilities,
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        codeLens = { enable = false },
        doc = { privateName = { '^_' } },
      },
    },
  })
end)

later(function()
  add({ source = 'mfussenegger/nvim-dap-python' })
  add({ source = 'theHamsta/nvim-dap-virtual-text' })
  add({ source = 'mfussenegger/nvim-dap' })

  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

  require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })

  local debugpy_path = Config.get_install_path('debugpy')

  if not debugpy_path then
    vim.notify('You need to install `debugpy` for dap to work properly', vim.log.levels.ERROR)
    return
  end

  require('dap-python').setup(debugpy_path .. '/venv/bin/python')
  require('dap.ext.vscode').json_decode = Config.json_decode
end)
