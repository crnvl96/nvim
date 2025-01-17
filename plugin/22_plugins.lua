local H = {}
local deps = require('mini.deps')
local add, now, later = deps.add, deps.now, deps.later

---
--- Helpers
---

function H.build(params, cmd)
  local notif = function(msg, lvl) vim.notify(msg, vim.log.levels[lvl]) end
  local pref = 'Building ' .. params.name

  notif(pref, 'INFO')

  local obj = vim.system(cmd, { cwd = params.path }):wait()
  local res = obj.code == 0 and (pref .. ' done') or (pref .. ' failed')
  local lvl = obj.code == 0 and 'INFO' or 'ERROR'

  notif(res, lvl)
end

---
--- Plugins
---

now(function()
  add({
    source = 'williamboman/mason.nvim',
    hooks = {
      post_checkout = function() vim.cmd('MasonUpdate') end,
    },
  })

  require('mason').setup()

  later(function()
    local mr = require('mason-registry')

    mr.refresh(function()
      for _, tool in ipairs({
        -- javascript/typescript
        'vtsls',
        'eslint_d',
        'prettierd',
        -- lua
        'lua-language-server',
        'stylua',
        'selene',
        -- python
        'basedpyright',
        'ruff',
        'debugpy',
        -- sql
        'sqlfluff',
      }) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)

now(function()
  add({
    source = 'junegunn/fzf',
    hooks = {
      post_checkout = function()
        later(function() vim.fn['fzf#install']() end)
      end,
      post_install = function()
        later(function() vim.fn['fzf#install']() end)
      end,
    },
  })

  add('nvim-lua/plenary.nvim')
  add('tpope/vim-sleuth')
  add('lambdalisue/vim-suda')
  add('tpope/vim-fugitive')
  add('tpope/vim-rhubarb')
  add('mfussenegger/nvim-lint')
end)

later(function()
  add('hat0uma/csvview.nvim')
  require('csvview').setup()
end)

later(function()
  add('jinh0/eyeliner.nvim')

  require('eyeliner').setup({
    highlight_on_key = true,
    dim = true,
  })
end)

now(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })

  require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    indent = { enable = true, disable = { 'yaml' } },
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

      -- sql
      'sql',

      -- csv
      'csv',
    },
  })
end)

now(function()
  add('folke/snacks.nvim')

  vim.api.nvim_set_hl(0, 'SnacksPickerMatch', { default = true, bg = '#e3d3a8', fg = '#242526' })

  require('snacks').setup({
    bigfile = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scratch = { ft = function() return 'markdown' end },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  })

  later(function()
    _G.dd = function(...) Snacks.debug.inspect(...) end
    _G.bt = function() Snacks.debug.backtrace() end
    vim.print = _G.dd

    Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
    Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
    Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
    Snacks.toggle.diagnostics():map('<leader>ud')
    Snacks.toggle.line_number():map('<leader>ul')
    Snacks.toggle.option('conceallevel', { off = 0, on = 2 }):map('<leader>uc')
    Snacks.toggle.treesitter():map('<leader>uT')
    Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
    Snacks.toggle.inlay_hints():map('<leader>uh')
    Snacks.toggle.indent():map('<leader>ug')
    Snacks.toggle.dim():map('<leader>uD')

    local autofmt = {
      name = 'Autoformat (conform.nvim)',
      get = function() return vim.g.autoformat end,
      set = function(enabled) vim.g.autoformat = enabled end,
    }

    Snacks.toggle(autofmt):map('<leader>uf')
  end)
end)

later(function()
  add({ source = 'kevinhwang91/nvim-bqf' })

  require('bqf').setup({
    auto_enable = true,
    auto_resize_height = false,
    preview = {
      win_height = 20,
      win_vheight = 20,
      delay_syntax = 80,
      border = 'rounded',
      show_title = false,
      should_preview_cb = function(bufnr)
        local ret = true
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local fsize = vim.fn.getfsize(bufname)
        if fsize > 100 * 1024 then
          ret = false
        elseif bufname:match('^fugitive://') then
          ret = false
        end
        return ret
      end,
    },
    func_map = {
      open = '',
      drop = '<CR>',
      tabc = '<C-w>t',
      split = '<C-w>s',
      vsplit = '<C-w>v',
    },
    filter = {
      fzf = {
        action_for = { ['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop', ['ctrl-v'] = 'vsplit' },
        extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ', '--delimiter', '│' },
      },
    },
  })
end)

later(function()
  add({ source = 'Vigemus/iron.nvim' })

  require('iron.core').setup({
    config = {
      scratch_repl = true,
      repl_definition = {
        sh = { command = { 'bash' } },
        python = {
          command = { 'uv', 'run', 'python' },
          format = require('iron.fts.common').bracketed_paste_python,
        },
      },
      repl_open_cmd = require('iron.view').right(40),
    },
    highlight = { italic = true },
    ignore_blank_lines = false,
  })
end)

later(function()
  add({ source = 'saghen/blink.compat' })

  add({
    source = 'Saghen/blink.cmp',
    hooks = {
      post_checkout = function(params) H.build(params, { 'cargo', 'build', '--release' }) end,
      post_install = function(params) H.build(params, { 'cargo', 'build', '--release' }) end,
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
      list = {
        selection = {
          preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
          auto_insert = function(ctx) return ctx.mode == 'cmdline' end,
        },
      },
      menu = {
        border = 'rounded',
        scrollbar = false,
        draw = {
          treesitter = { 'lsp' },
          columns = { { 'kind_icon' }, { 'label', gap = 1 } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = {
          border = 'rounded',
          scrollbar = false,
        },
      },
    },
    sources = {
      transform_items = function(_, items)
        return vim.tbl_filter(
          function(item) return item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet end,
          items
        )
      end,

      default = { 'lsp', 'path', 'buffer' },
      per_filetype = {
        codecompanion = { 'path' },
      },
    },
    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },
  })
end)

later(function()
  add({ source = 'olimorris/codecompanion.nvim' })

  local path = vim.fn.stdpath('config') .. '/anthropic'
  local file = io.open(path, 'r')
  local key

  if file then
    key = file:read('*a'):gsub('%s+$', '')
    file:close()
  end

  if not key then
    vim.notify('An `anthropic` key must be set for a proper config setup', vim.log.levels.ERROR)
    return
  end

  require('codecompanion').setup({
    strategies = {
      chat = {
        adapter = 'anthropic',
        keymaps = {
          completion = {
            modes = {
              i = '<C-t>',
            },
            index = 1,
            callback = 'keymaps.completion',
            description = 'Completion Menu',
          },
        },
      },
      inline = { adapter = 'anthropic' },
      cmd = { adapter = 'anthropic' },
    },
    adapters = {
      anthropic = require('codecompanion.adapters').extend('anthropic', {
        env = { api_key = key },
        schema = {
          model = {
            default = 'claude-3-5-haiku-20241022',
            -- default = 'claude-3-5-sonnet-20241022',
          },
        },
      }),
    },
  })
end)

later(function()
  add({ source = 'stevearc/conform.nvim' })

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  vim.g.autoformat = true

  require('conform').setup({
    notify_on_error = true,
    formatters_by_ft = {
      markdown = { 'prettierd', 'injected' },
      md = { 'prettierd', 'injected' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
      liquid = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      html = { 'prettierd' },
      yaml = { 'prettierd' },
      toml = { 'taplo' },
      lua = { 'stylua' },
      sql = { 'sqlfluff' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      ['javascript.tsx'] = { 'prettierd' },
      ['typescript.tsx'] = { 'prettierd' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
    },
    formatters = {
      injected = { ignore_errors = true },
      sqlfluff = {
        args = { 'format', '--dialect=ansi', '-' },
      },
    },
  })
end)

later(function()
  add({ source = 'theHamsta/nvim-dap-virtual-text' })
  add({ source = 'mfussenegger/nvim-dap' })
  add({ source = 'mfussenegger/nvim-dap-python' })

  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

  require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })

  require('dap.ext.vscode').json_decode = function(data)
    local decode = vim.json.decode
    local strip_comments = require('plenary.json').json_strip_comments
    data = strip_comments(data)

    return decode(data)
  end

  require('dap-python').setup(require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python')
end)

later(function()
  add({ source = 'neovim/nvim-lspconfig' })

  local servers = {
    vtsls = {
      root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'package.json' }) end,
      single_file_support = false,
    },
    basedpyright = {
      settings = {
        basedpyright = {
          typeCheckingMode = 'basic', -- Options: "off", "basic", "strict"
        },
      },
    },
    lua_ls = {
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          diagnostics = {
            globals = {
              'vim',
              'MiniPick',
              'MiniClue',
              'MiniDeps',
              'MiniNotify',
              'MiniIcons',
            },
          },
          runtime = {
            version = 'LuaJIT',
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              '${3rd}/luv/library',
            },
          },
        })
      end,
      settings = {
        Lua = {
          format = { enable = false },
          hint = {
            enable = true,
            arrayIndex = 'Disable',
          },
          completion = {
            callSnippet = 'Disable',
            keywordSnippet = 'Disable',
          },
        },
      },
    },
  }

  local ok = pcall(require, 'blink.cmp')
  if not ok then
    vim.notify('blink.cmp must be installed to have access to full capabilities.', vim.log.levels.ERROR)
  end

  local capabilities = require('blink.cmp').get_lsp_capabilities(
    vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = false,
          },
        },
      },
    })
  )

  for server, config in pairs(servers) do
    config = config or {}
    local opts = { capabilities = capabilities }
    config = vim.tbl_deep_extend('force', config, opts)
    require('lspconfig')[server].setup(config)
  end
end)
