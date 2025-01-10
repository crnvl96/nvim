local hooks = {}
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local set = vim.keymap.set

local function build(params, build_cmd)
  vim.notify('Building ' .. params.name, vim.log.levels.INFO)
  local obj = vim.system(build_cmd, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building ' .. params.name .. ' done', vim.log.levels.INFO)
  else
    vim.notify('Building ' .. params.name .. ' failed', vim.log.levels.ERROR)
  end
end

hooks.mkdp = {
  post_checkout = function()
    later(function() vim.fn['mkdp#util#install']() end)
  end,
  post_install = function()
    later(function() vim.fn['mkdp#util#install']() end)
  end,
}

hooks.fzf = {
  post_checkout = function()
    later(function() vim.fn['fzf#install']() end)
  end,
  post_install = function()
    later(function() vim.fn['fzf#install']() end)
  end,
}

hooks.blink = {
  post_checkout = function(params) build(params, { 'cargo', 'build', '--release' }) end,
  post_install = function(params) build(params, { 'cargo', 'build', '--release' }) end,
}

hooks.treesitter = {
  post_checkout = function() vim.cmd('TSUpdate') end,
}

hooks.mason = {
  post_checkout = function() vim.cmd('MasonUpdate') end,
}

now(function() add({ name = 'mini.nvim' }) end)
now(function() vim.cmd('colorscheme minigrey') end)

now(function()
  local mininotify = require('mini.notify')

  local function filter_fn(el) return not vim.startswith(el.msg, 'lua_ls: Diagnosing') end
  local function sort_fn(list)
    list = vim.tbl_filter(filter_fn, list)
    return MiniNotify.default_sort(list)
  end

  mininotify.setup({ content = { sort = sort_fn } })
  vim.notify = mininotify.make_notify()
end)

now(function()
  local miniicons = require('mini.icons')

  miniicons.setup()
  miniicons.mock_nvim_web_devicons()
  later(miniicons.tweak_lsp_kind)
end)

later(function()
  add({ source = 'williamboman/mason.nvim', hooks = hooks.mason })

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
      }) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)

later(function() require('mini.doc').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.operators').setup() end)
later(function() require('mini.diff').setup({ view = { style = 'sign' } }) end)
later(function() vim.ui.select = require('mini.pick').ui_select end)
later(function() add({ source = 'nvim-lua/plenary.nvim' }) end)
later(function() add({ source = 'tpope/vim-sleuth' }) end)
later(function() add({ source = 'junegunn/fzf', hooks = hooks.fzf }) end)
later(function() add({ source = 'kevinhwang91/promise-async' }) end)
later(function() add({ source = 'lambdalisue/vim-suda' }) end)
later(function() add({ source = 'HakonHarnes/img-clip.nvim' }) end)
later(function() add({ source = 'tpope/vim-fugitive' }) end)
later(function() add({ source = 'iamcco/markdown-preview.nvim', hooks = hooks.mkdp }) end)

later(function()
  MiniDeps.add({ source = 'hat0uma/csvview.nvim' })
  require('csvview').setup()
end)

later(function()
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
end)

later(function()
  add({ source = 'nvim-treesitter/nvim-treesitter', hooks = hooks.treesitter })

  local ts = require('nvim-treesitter.configs')

  ts.setup({
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

later(function()
  add({ source = 'mfussenegger/nvim-lint' })

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

later(function()
  add({ source = 'kevinhwang91/nvim-bqf' })

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
      tabc = '<C-t>',
      split = '<C-s>',
      vsplit = '<C-v>',
    },
    filter = {
      fzf = {
        action_for = { ['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop' },
        extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ', '--delimiter', '│' },
      },
    },
  })
end)

later(function()
  add({ source = 'saghen/blink.compat' })
  add({ source = 'Saghen/blink.cmp', hooks = hooks.blink })

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
          },
        },
      }),
    },
  })
end)

later(function()
  add({ source = 'stevearc/conform.nvim' })

  require('conform').setup({
    notify_on_error = true,
    formatters_by_ft = {
      markdown = { 'prettierd', 'injected' },
      css = { 'prettierd' },
      html = { 'prettierd' },
      json = { 'prettierd' },
      toml = { 'taplo' },
      lua = { 'stylua' },
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

later(function()
  add({ source = 'neovim/nvim-lspconfig' })

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
  }) do
    config = vim.tbl_deep_extend('force', config or {}, { capabilities = capabilities })
    require('lspconfig')[server].setup(config)
  end
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
  add({ source = 'chrisgrieser/nvim-origami' })
  add({ source = 'kevinhwang91/nvim-ufo' })

  require('origami').setup({ keepFoldsAcrossSessions = false, hOnlyOpensOnFirstColumn = true })

  require('ufo').setup({
    provider_selector = function(_, ft, _)
      local lspWithOutFolding = { 'markdown', 'sh', 'css', 'html', 'python' }
      if vim.tbl_contains(lspWithOutFolding, ft) then return { 'treesitter', 'indent' } end
      return { 'lsp', 'indent' }
    end,
    open_fold_hl_timeout = 800,
  })
end)

later(function()
  add({ source = 'crnvl96/nvim-deck' })

  local deck = require('deck')

  deck.setup({
    max_history_size = 5,
    default_start_config = {
      view = function()
        return require('deck.builtin.view.default').create({
          max_height = math.floor(vim.o.lines * 0.25),
        })
      end,
      matcher = require('deck.builtin.matcher').default,
      history = true,
      performance = {
        interrupt_interval = 8,
        interrupt_timeout = 8,
      },
    },
  })

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

      ctx.keymap('n', 'S', deck.action_mapping('substitute'))

      ctx.keymap('n', 's', deck.action_mapping('open_split'))
      ctx.keymap('n', 'v', deck.action_mapping('open_vsplit'))

      ctx.keymap('n', '<C-b>', deck.action_mapping('scroll_preview_up'))
      ctx.keymap('n', '<C-f>', deck.action_mapping('scroll_preview_down'))
    end,
  })
end)

later(function()
  add({ source = 'Vigemus/iron.nvim' })

  local iron = require('iron.core')
  iron.setup({
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
  local miniclue = require('mini.clue')

  miniclue.setup({
    clues = {
      { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<Leader>c', desc = '+CodeCompanion' },
      { mode = 'n', keys = '<Leader>c', desc = '+CodeCompanion' },
      { mode = 'n', keys = '<Leader>d', desc = '+Debug' },
      { mode = 'n', keys = '<Leader>e', desc = '+Explorer' },
      { mode = 'n', keys = '<Leader>f', desc = '+Files' },
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'x', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>i', desc = '+Iron' },
      { mode = 'x', keys = '<Leader>i', desc = '+Iron' },
      { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
      { mode = 'n', keys = '<Leader>n', desc = '+Notification' },

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

later(function()
  local function deck_git() require('deck').start(require('deck.builtin.source.git')({ cwd = vim.uv.cwd() })) end

  local function deck_resume()
    local ctx = require('deck').get_history()[1]
    if ctx then ctx.show() end
  end

  local function deck_lines()
    require('deck').start(require('deck.builtin.source.lines')({
      bufnrs = { vim.api.nvim_get_current_buf() },
    }))
  end

  local function deck_files()
    require('deck').start({
      require('deck.builtin.source.files')({
        root_dir = vim.uv.cwd(),
        ignore_globs = {
          '**/node_modules/**',
          '**/.git/**',
        },
      }),
    })
  end

  local function deck_buffers()
    require('deck').start({
      require('deck.builtin.source.buffers')(),
    })
  end

  local function deck_help() require('deck').start(require('deck.builtin.source.helpgrep')()) end

  local function deck_oldfiles()
    require('deck').start({
      require('deck.builtin.source.recent_files')(),
    })
  end

  local function deck_grep()
    local pattern = vim.fn.input('grep: ')
    if #pattern == 0 then return vim.notify('Canceled', vim.log.levels.INFO) end

    require('deck').start(require('deck.builtin.source.grep')({
      pattern = pattern,
      root_dir = vim.uv.cwd(),
      ignore_globs = {
        '**/node_modules/**',
        '**/.git/**',
        '--hidden',
      },
    }))
  end

  local function dap_scopes() require('dap.ui.widgets').sidebar(require('dap.ui.widgets').scopes, {}, 'vsplit').toggle() end

  set('n', '-', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')

  set('x', '<Leader>cc', '<Cmd>CodeCompanionChat Add<CR>', { desc = 'Add to chat buffer' })

  set('n', '<Leader>ba', '<Cmd>b#<CR>', { desc = 'Alternate buffer' })
  set('n', '<Leader>bd', '<Cmd>bd<CR>', { desc = 'Delete current buffer' })
  set('n', '<Leader>ca', '<Cmd>CodeCompanionActions<CR>', { desc = 'Show AI actions' })
  set('n', '<Leader>ct', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle chat buffer' })
  set('n', '<Leader>dR', '<Cmd>lua require("dap.repl").toggle({}, "belowright split")<CR>', { desc = 'Repl' })
  set('n', '<Leader>db', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', { desc = 'Set breakpoint' })
  set('n', '<Leader>dc', '<Cmd>lua require("dap").clear_breakpoints()<CR>', { desc = 'Clear breakpoints' })
  set('n', '<Leader>de', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { desc = 'Eval' })
  set('n', '<Leader>dr', '<Cmd>lua require("dap").continue()<CR>', { desc = 'Continue' })
  set('n', '<Leader>ds', dap_scopes, { desc = 'Scopes' })
  set('n', '<Leader>dt', '<Cmd>lua require("dap").terminate()<CR>', { desc = 'Terminate' })
  set('n', '<Leader>du', '<Cmd>lua require("dap").run_to_cursor()<CR>', { desc = 'Run to cursor' })
  set('n', '<Leader>fb', deck_buffers, { desc = 'Buffers' })
  set('n', '<Leader>ff', deck_files, { desc = 'Find files' })
  set('n', '<Leader>fg', deck_grep, { desc = 'Grep' })
  set('n', '<Leader>fh', deck_help, { desc = 'Help tags' })
  set('n', '<Leader>fl', deck_lines, { desc = 'Buffer lines' })
  set('n', '<Leader>fo', deck_oldfiles, { desc = 'Oldfiles' })
  set('n', '<Leader>fr', deck_resume, { desc = 'Resume last context' })
  set('n', '<Leader>gg', deck_git, { desc = 'Git' })
  set('n', '<Leader>ia', '<cmd>IronAttach<cr>', { desc = 'Iron Attach' })
  set('n', '<Leader>ih', '<cmd>IronHide<cr>', { desc = 'Iron Hide' })
  set('n', '<Leader>io', '<cmd>IronFocus<cr>', { desc = 'Iron Focus' })
  set('n', '<Leader>ie', '<cmd>IronRepl<cr>', { desc = 'Iron Repl' })
  set('n', '<Leader>ir', '<cmd>IronRestart<cr>', { desc = 'Iron Restart' })
  set('n', '<Leader>is', '<cmd>IronSend<cr>', { desc = 'Iron Send' })
  set('n', '<Leader>nh', '<Cmd>lua MiniNotify.show_history()<CR>', { desc = 'Show notification history' })
end)
