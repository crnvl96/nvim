MiniDeps.now(function()
  for _, cli in ipairs({
    'tree-sitter',
    'rg',
    'rustc',
    'npm',
  }) do
    if vim.fn.executable(cli) ~= 1 then
      local msg = cli .. ' is not installed in the system.'
      local lvl = vim.log.levels.ERROR

      vim.notify(msg, lvl)
    end
  end
end)

MiniDeps.now(function() MiniDeps.add({ name = 'mini.nvim' }) end)

MiniDeps.now(function()
  require('mini.notify').setup({
    content = {
      sort = function(list)
        return MiniNotify.default_sort(
          vim.tbl_filter(function(el) return not vim.startswith(el.msg, 'lua_ls: Diagnosing') end, list)
        )
      end,
    },
  })
  vim.notify = MiniNotify.make_notify()
  vim.keymap.set('n', '<Leader>nh', '<Cmd>lua MiniNotify.show_history()<CR>', { desc = 'Show notification history' })
end)

MiniDeps.now(function() require('mini.misc').setup_termbg_sync() end)
MiniDeps.now(function() vim.cmd('colorscheme minigrey') end)

MiniDeps.now(function()
  MiniDeps.add({ source = 'folke/snacks.nvim' })

  require('snacks').setup({
    indent = { enabled = true },
  })
end)

MiniDeps.now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })

  MiniIcons.mock_nvim_web_devicons()
  MiniDeps.later(MiniIcons.tweak_lsp_kind)
end)

MiniDeps.later(function() require('mini.doc').setup() end)
MiniDeps.later(function() require('mini.align').setup() end)
MiniDeps.later(function() require('mini.operators').setup() end)
MiniDeps.later(function() MiniDeps.add({ source = 'nvim-lua/plenary.nvim' }) end)
MiniDeps.later(function() MiniDeps.add({ source = 'lambdalisue/vim-suda' }) end)
MiniDeps.later(function() MiniDeps.add({ source = 'HakonHarnes/img-clip.nvim' }) end)
MiniDeps.later(function() MiniDeps.add({ source = 'tpope/vim-sleuth' }) end)
MiniDeps.later(function() MiniDeps.add({ source = 'tpope/vim-fugitive' }) end)

MiniDeps.later(function()
  require('mini.pick').setup()
  vim.ui.select = MiniPick.ui_select
end)

MiniDeps.later(function()
  MiniDeps.add({ source = 'hat0uma/csvview.nvim' })
  require('csvview').setup()
end)

MiniDeps.later(function()
  require('mini.diff').setup({ view = { style = 'sign' } })
  vim.keymap.set('n', '<Leader>go', '<Cmd>lua MiniDiff.toggle_overlay(0)<CR>', { desc = 'Toggle diff overlay' })
end)

MiniDeps.later(function()
  local minifiles = require('mini.files')

  minifiles.setup({
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
    },
    windows = { width_nofocus = 25, preview = true, width_preview = 50 },
    options = { permanent_delete = false },
  })

  vim.keymap.set('n', '-', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
end)

MiniDeps.later(function()
  MiniDeps.add({
    source = 'iamcco/markdown-preview.nvim',
    hooks = {
      post_checkout = function()
        MiniDeps.later(function() vim.fn['mkdp#util#install']() end)
      end,
      post_install = function()
        MiniDeps.later(function() vim.fn['mkdp#util#install']() end)
      end,
    },
  })

  vim.g.mkdp_filetypes = { 'markdown', 'md' }
end)

MiniDeps.later(function()
  MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
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
    },
  })
end)

MiniDeps.later(function()
  MiniDeps.add({ source = 'mfussenegger/nvim-lint' })

  local linters = {
    lua = {
      cond = function(buf) return vim.fs.root(buf, { 'selene.toml' }) ~= nil end,
      linters = { 'selene' },
    },
    python = { linters = { 'ruff' } },
    javascript = { linters = { 'eslint_d' } },
    typescript = { linters = { 'eslint_d' } },
    javascriptreact = { linters = { 'eslint_d' } },
    typescriptreact = { linters = { 'eslint_d' } },
    ['javascript.tsx'] = { linters = { 'eslint_d' } },
    ['typescript.tsx'] = { linters = { 'eslint_d' } },
  }

  vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('crnvl96-nvim-lint', { clear = true }),
    callback = function(e)
      local buf = e.buf
      local ft = vim.bo[buf].filetype
      local conf = linters[ft]
      if conf and (not conf.cond or conf.cond(buf)) then require('lint').try_lint(conf.linters) end
    end,
  })
end)

MiniDeps.later(function()
  MiniDeps.add({
    source = 'williamboman/mason.nvim',
    hooks = { post_checkout = function() vim.cmd('MasonUpdate') end },
  })

  require('mason').setup()

  MiniDeps.later(function()
    local mr = require('mason-registry')

    mr.refresh(function()
      for _, tool in ipairs({
        -- javascript/typescript
        'vtsls',
        'eslint_d',
        'deno',
        'prettierd',

        -- lua
        'lua-language-server',
        'stylua',
        'selene',

        -- python
        'basedpyright',
        'ruff',
        'debugpy',
      }) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)

MiniDeps.later(function()
  MiniDeps.add({
    source = 'junegunn/fzf',
    hooks = {
      post_checkout = function()
        MiniDeps.later(function() vim.fn['fzf#install']() end)
      end,
      post_install = function()
        MiniDeps.later(function() vim.fn['fzf#install']() end)
      end,
    },
  })
end)

MiniDeps.later(function()
  MiniDeps.add({ source = 'kevinhwang91/nvim-bqf' })

  require('bqf').setup({
    auto_enable = true,
    auto_resize_height = false,
    preview = {
      win_height = 20,
      win_vheight = 20,
      delay_syntax = 80,
      border = 'single',
      show_title = false,
      should_preview_cb = function(bufnr)
        local ret = true
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local fsize = vim.fn.getfsize(bufname)
        if fsize > 100 * 1024 then
          -- skip file size greater than 100k
          ret = false
        elseif bufname:match('^fugitive://') then
          -- skip fugitive buffer
          ret = false
        end
        return ret
      end,
    },
    filter = {
      fzf = {
        action_for = { ['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop' },
        extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ', '--delimiter', '│' },
      },
    },
  })
end)

MiniDeps.later(function()
  MiniDeps.add({ source = 'aaronik/treewalker.nvim' })

  require('treewalker').setup({
    highlight = true,
    highlight_duration = 250,
    highlight_group = 'CursorLine',
  })

  vim.keymap.set('n', '<Leader>wj', '<Cmd>Treewalker Down<CR>', { desc = 'Treewalker down' })
  vim.keymap.set('n', '<Leader>wk', '<Cmd>Treewalker Up<CR>', { desc = 'Treewalker up' })
  vim.keymap.set('n', '<Leader>wh', '<Cmd>Treewalker Left<CR>', { desc = 'Treewalker left' })
  vim.keymap.set('n', '<Leader>wl', '<Cmd>Treewalker Right<CR>', { desc = 'Treewalker right' })
end)

MiniDeps.later(function()
  MiniDeps.add({ source = 'saghen/blink.compat' })
  MiniDeps.add({
    source = 'Saghen/blink.cmp',
    hooks = {
      post_checkout = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
      post_install = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
    },
  })

  require('blink.compat').setup()
  require('blink.cmp').setup({
    enabled = function()
      return not vim.tbl_contains({ 'minifiles', 'markdown', 'deck' }, vim.bo.filetype)
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
        border = 'single',
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
          border = 'single',
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
      window = { border = 'single' },
    },
  })
end)

MiniDeps.later(function()
  MiniDeps.add({ source = 'olimorris/codecompanion.nvim' })

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

  vim.keymap.set('x', '<Leader>ic', '<Cmd>CodeCompanionChat Add<CR>', { desc = 'Add to chat buffer' })
  vim.keymap.set('n', '<Leader>it', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle chat buffer' })
  vim.keymap.set('n', '<Leader>ia', '<Cmd>CodeCompanionActions<CR>', { desc = 'Show AI actions' })
end)

MiniDeps.later(function()
  MiniDeps.add({ source = 'stevearc/conform.nvim' })

  require('conform').setup({
    notify_on_error = true,
    formatters_by_ft = {
      markdown = { 'prettierd', 'injected' },
      css = { 'prettierd' },
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

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(e)
      require('conform').format({
        bufnr = e.buf,
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = 'fallback',
      })
    end,
  })
end)

MiniDeps.later(function()
  MiniDeps.add({ source = 'neovim/nvim-lspconfig' })

  local ok = pcall(require, 'blink.cmp')
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  if not ok then
    vim.notify('blink.cmp must be installed to have access to full capabilities.', vim.log.levels.ERROR)
  end

  capabilities = require('blink.cmp').get_lsp_capabilities(vim.tbl_deep_extend('force', capabilities, {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
      },
    },
  }))

  for server, config in pairs({
    vtsls = {
      root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'package.json' }) end,
      single_file_support = false, -- avoid setting up vtsls on deno projects
    },
    denols = {
      root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'deno.json', 'deno.jsonc' }) end,
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
          -- Using stylua for formatting.
          format = { enable = false },
          hint = {
            enable = true,
            arrayIndex = 'Disable',
          },
          -- completion = { callSnippet = 'Replace' },
          completion = {
            callSnippet = 'Disable',
            keywordSnippet = 'Disable',
          },
        },
      },
    },
  }) do
    config = vim.tbl_deep_extend('force', config or {}, { capabilities = capabilities })
    require('lspconfig')[server].setup(config)
  end
end)

MiniDeps.later(function()
  MiniDeps.add({ source = 'theHamsta/nvim-dap-virtual-text' })
  MiniDeps.add({ source = 'mfussenegger/nvim-dap' })
  MiniDeps.add({ source = 'mfussenegger/nvim-dap-python' })

  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
  require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })

  require('dap.ext.vscode').json_decode = function(data)
    local decode = vim.json.decode
    local strip_comments = require('plenary.json').json_strip_comments
    data = strip_comments(data)

    return decode(data)
  end

  require('dap-python').setup(require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python')

  local set = vim.keymap.set

  local scopes =
    '<Cmd>lua require("dap.ui.widgets").sidebar(require("dap.ui.widgets").scopes, {}, "vsplit").toggle()<CR>'

  set('n', '<Leader>dc', '<Cmd>lua require("dap").clear_breakpoints()<CR>', { desc = 'Clear breakpoints' })
  set('n', '<Leader>db', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', { desc = 'Set breakpoint' })
  set('n', '<Leader>du', '<Cmd>lua require("dap").run_to_cursor()<CR>', { desc = 'Run to cursor' })
  set('n', '<Leader>dr', '<Cmd>lua require("dap").continue()<CR>', { desc = 'Continue' })
  set('n', '<Leader>de', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { desc = 'Eval' })
  set('n', '<Leader>dR', '<Cmd>lua require("dap.repl").toggle({}, "belowright split")<CR>', { desc = 'Repl' })
  set('n', '<Leader>dt', '<Cmd>lua require("dap").terminate()<CR>', { desc = 'Terminate' })
  set('n', '<Leader>ds', scopes, { desc = 'Scopes' })
end)

MiniDeps.later(function()
  MiniDeps.add({ source = 'kevinhwang91/promise-async' })
  MiniDeps.add({ source = 'chrisgrieser/nvim-origami' })
  MiniDeps.add({ source = 'kevinhwang91/nvim-ufo' })

  require('origami').setup({ keepFoldsAcrossSessions = false })

  require('ufo').setup({
    provider_selector = function(_, ft, _)
      local lspWithOutFolding = { 'markdown', 'sh', 'css', 'html', 'python' }
      if vim.tbl_contains(lspWithOutFolding, ft) then return { 'treesitter', 'indent' } end
      return { 'lsp', 'indent' }
    end,
    open_fold_hl_timeout = 800,
  })
end)

MiniDeps.later(function()
  MiniDeps.add({ source = 'hrsh7th/nvim-deck' })

  local deck = require('deck')

  vim.api.nvim_create_autocmd('User', {
    pattern = 'DeckStart',
    callback = function(e)
      local ctx = e.data.ctx

      ctx.keymap('n', '<CR>', deck.action_mapping('default'))
      ctx.keymap('n', '<Tab>', deck.action_mapping('choose_action'))
      ctx.keymap('n', '<C-l>', deck.action_mapping('refresh'))
      ctx.keymap('n', 'i', deck.action_mapping('prompt'))
      ctx.keymap('n', 'a', deck.action_mapping('prompt'))
      ctx.keymap('n', '@', deck.action_mapping('toggle_select'))
      ctx.keymap('n', '*', deck.action_mapping('toggle_select_all'))
      ctx.keymap('n', 'p', deck.action_mapping('toggle_preview_mode'))
      ctx.keymap('n', 'q', function() ctx.hide() end)

      ctx.keymap('n', 's', deck.action_mapping('open_split'))
      ctx.keymap('n', 'v', deck.action_mapping('open_vsplit'))

      ctx.keymap('n', '<C-u>', deck.action_mapping('scroll_preview_up'))
      ctx.keymap('n', '<C-d>', deck.action_mapping('scroll_preview_down'))
    end,
  })

  vim.keymap.set('n', '<Leader>fr', function()
    local ctx = require('deck').get_history()[1]
    if ctx then ctx.show() end
  end, { desc = 'Resume last context' })

  vim.keymap.set(
    'n',
    '<Leader>fl',
    function()
      deck.start(require('deck.builtin.source.lines')({
        bufnrs = { vim.api.nvim_get_current_buf() },
      }))
    end,
    { desc = 'Buffer lines' }
  )

  vim.keymap.set(
    'n',
    '<Leader>ff',
    function()
      deck.start({
        require('deck.builtin.source.files')({
          root_dir = vim.fn.getcwd(),
          ignore_globs = {
            '**/node_modules/**',
            '**/.git/**',
          },
        }),
      })
    end,
    { desc = 'Find files' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fb',
    function()
      deck.start({
        require('deck.builtin.source.buffers')(),
      })
    end,
    { desc = 'Buffers' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fh',
    function() deck.start(require('deck.builtin.source.helpgrep')()) end,
    { desc = 'Help tags' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fo',
    function()
      deck.start({
        require('deck.builtin.source.recent_files')(),
      })
    end,
    { desc = 'Oldfiles' }
  )

  vim.keymap.set('n', '<Leader>fg', function()
    local pattern = vim.fn.input('grep: ')
    if #pattern == 0 then return vim.notify('Canceled', vim.log.levels.INFO) end
    deck.start(require('deck.builtin.source.grep')({
      pattern = pattern,
      root_dir = vim.fn.getcwd(),
      ignore_globs = {
        '**/node_modules/**',
        '**/.git/**',
      },
    }))
  end, { desc = 'Grep' })
end)

MiniDeps.later(function()
  local miniclue = require('mini.clue')

  miniclue.setup({
    clues = {
      { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<Leader>d', desc = '+Debug' },
      { mode = 'n', keys = '<Leader>f', desc = '+Files' },
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'x', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>i', desc = '+IA' },
      { mode = 'x', keys = '<Leader>i', desc = '+IA' },
      { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
      { mode = 'n', keys = '<Leader>n', desc = '+Notification' },
      { mode = 'n', keys = '<Leader>x', desc = '+List' },

      { mode = 'n', keys = '<Leader>wj', postkeys = '<Leader>w', desc = 'Down' },
      { mode = 'n', keys = '<Leader>wk', postkeys = '<Leader>w', desc = 'Up' },
      { mode = 'n', keys = '<Leader>wh', postkeys = '<Leader>w', desc = 'Left' },
      { mode = 'n', keys = '<Leader>wl', postkeys = '<Leader>w', desc = 'Right' },

      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = '<Localleader>' },
      { mode = 'x', keys = '<Localleader>' },
      { mode = 'n', keys = [[\]] },
      { mode = 'n', keys = '[' },
      { mode = 'x', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'x', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },
    window = { delay = 200, config = { width = 'auto' } },
  })
end)
