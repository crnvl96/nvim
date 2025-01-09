_G.Hooks = {}
_G.Config = {}
_G.Plugins = {}

--
-- Plugins
--

Plugins.mininotify = function()
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
end

Plugins.miniicons = function()
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
  MiniDeps.later(MiniIcons.tweak_lsp_kind)
end

Plugins.csvview = function()
  MiniDeps.add({ source = 'hat0uma/csvview.nvim' })
  require('csvview').setup()
end

Plugins.minifiles = function()
  require('mini.files').setup({
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
    },
    windows = { width_nofocus = 25, preview = true, width_preview = 50 },
    options = { permanent_delete = false },
  })
end

Plugins.treesitter = function()
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
end

Plugins.nvim_lint = function()
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
end

Plugins.mason = function()
  require('mason').setup()

  MiniDeps.later(function()
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
end

Plugins.bqf = function()
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
    filter = {
      fzf = {
        action_for = { ['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop' },
        extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ', '--delimiter', '│' },
      },
    },
  })
end

Plugins.blink = function()
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
end

Plugins.codecompanion = function()
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
end

Plugins.conform = function()
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
end

Plugins.lspconfig = function()
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
end

Plugins.dap = function()
  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
  require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })

  require('dap.ext.vscode').json_decode = function(data)
    local decode = vim.json.decode
    local strip_comments = require('plenary.json').json_strip_comments
    data = strip_comments(data)

    return decode(data)
  end

  require('dap-python').setup(require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python')
end

Plugins.ufo = function()
  require('origami').setup({ keepFoldsAcrossSessions = false, hOnlyOpensOnFirstColumn = true })

  require('ufo').setup({
    provider_selector = function(_, ft, _)
      local lspWithOutFolding = { 'markdown', 'sh', 'css', 'html', 'python' }
      if vim.tbl_contains(lspWithOutFolding, ft) then return { 'treesitter', 'indent' } end
      return { 'lsp', 'indent' }
    end,
    open_fold_hl_timeout = 800,
  })
end

Plugins.nvim_deck = function()
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

      ctx.keymap('n', 'S', deck.action_mapping('substitute'))

      ctx.keymap('n', 's', deck.action_mapping('open_split'))
      ctx.keymap('n', 'v', deck.action_mapping('open_vsplit'))

      ctx.keymap('n', '<C-b>', deck.action_mapping('scroll_preview_up'))
      ctx.keymap('n', '<C-f>', deck.action_mapping('scroll_preview_down'))
    end,
  })
end

Plugins.iron = function()
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
end

Plugins.miniclue = function()
  local miniclue = require('mini.clue')

  miniclue.setup({
    clues = {
      { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<Leader>c', desc = '+CodeCompanion' },
      { mode = 'n', keys = '<Leader>c', desc = '+CodeCompanion' },
      { mode = 'n', keys = '<Leader>d', desc = '+Debug' },
      { mode = 'n', keys = '<Leader>f', desc = '+Files' },
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'x', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>i', desc = '+Iron' },
      { mode = 'x', keys = '<Leader>i', desc = '+Iron' },
      { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
      { mode = 'n', keys = '<Leader>n', desc = '+Notification' },
      { mode = 'n', keys = '<Leader>x', desc = '+List' },

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
end

--
-- Hooks
--

Hooks.mkdp = {
  post_checkout = function()
    MiniDeps.later(function() vim.fn['mkdp#util#install']() end)
  end,
  post_install = function()
    MiniDeps.later(function() vim.fn['mkdp#util#install']() end)
  end,
}

Hooks.fzf = {
  post_checkout = function()
    MiniDeps.later(function() vim.fn['fzf#install']() end)
  end,
  post_install = function()
    MiniDeps.later(function() vim.fn['fzf#install']() end)
  end,
}

Hooks.blink = {
  post_checkout = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
  post_install = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
}

Hooks.treesitter = {
  post_checkout = function() vim.cmd('TSUpdate') end,
}

Hooks.mason = {
  post_checkout = function() vim.cmd('MasonUpdate') end,
}

--
-- Config
--

function Config.build(params, build_cmd)
  vim.notify('Building ' .. params.name, vim.log.levels.INFO)
  local obj = vim.system(build_cmd, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building ' .. params.name .. ' done', vim.log.levels.INFO)
  else
    vim.notify('Building ' .. params.name .. ' failed', vim.log.levels.ERROR)
  end
end

function Config.qftf(info)
  local items
  local ret = {}

  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end

  local limit = 62
  local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local validFmt = '%s │%5d:%-3d│%s %s'

  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = vim.fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end

  return ret
end
