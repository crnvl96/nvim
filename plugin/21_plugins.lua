local deps = require('mini.deps')

local add, now, later = deps.add, deps.now, deps.later
local set = vim.keymap.set

local build = function(params, cmd)
  local notif = function(msg, lvl) vim.notify(msg, vim.log.levels[lvl]) end
  local pref = 'Building ' .. params.name

  notif(pref, 'INFO')

  local obj = vim.system(cmd, { cwd = params.path }):wait()
  local res = obj.code == 0 and (pref .. ' done') or (pref .. ' failed')
  local lvl = obj.code == 0 and 'INFO' or 'ERROR'

  notif(res, lvl)
end

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

now(function() require('mini.icons').setup() end)

now(function() require('mini.doc').setup() end)

now(function() require('mini.align').setup() end)

now(function() require('mini.splitjoin').setup() end)

now(function() require('mini.operators').setup() end)

now(function()
  require('mini.diff').setup({
    view = {
      style = 'sign',
    },
  })
  vim.keymap.set('n', '<Leader>go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', { desc = 'Toggle overlay' })
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

  -- vim.api.nvim_set_hl(0, 'SnacksPickerListCursorLine', { default = true, fg = '#f0f0f0' })
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
  end)

  set('n', '<leader>z', function() Snacks.zen() end, { desc = 'Toggle Zen Mode' })
  set('n', '<leader><space>', function() Snacks.zen.zoom() end, { desc = 'Toggle Zoom' })
  set('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Toggle Scratch Buffer' })

  set('n', '<leader>n', function() Snacks.notifier.show_history() end, { desc = 'Notification History' })
  set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
  set('n', '<leader>gb', function() Snacks.git.blame_line() end, { desc = 'Git Blame Line' })
  set('n', '<leader>un', function() Snacks.notifier.hide() end, { desc = 'Dismiss All Notifications' })

  set({ 'n', 'v' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })

  set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next Reference' })
  set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev Reference' })

  set('n', '<C-t>', function() Snacks.terminal() end, { desc = 'Terminal' })
  set('t', '<C-t>', '<cmd>close<cr>', { desc = 'Hide Terminal' })

  set('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
  set('n', '<leader>fg', function() Snacks.picker.grep({ hidden = true }) end, { desc = 'Grep' })
  set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find Files' })
  set('n', '<leader>fo', function() Snacks.picker.recent() end, { desc = 'Recent' })
  set('n', '<leader>fl', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
  set('n', '<leader>fh', function() Snacks.picker.help() end, { desc = 'Help Pages' })
  set('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
  set('n', '<leader>fm', function() Snacks.picker.marks() end, { desc = 'Marks' })
  set('n', '<leader>fr', function() Snacks.picker.resume() end, { desc = 'Resume' })
  set('n', '<leader>fx', function() Snacks.picker.qflist() end, { desc = 'Quickfix List' })
  set('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Projects' })
  set('n', '<leader>fz', function() Snacks.picker.zoxide() end, { desc = 'Z' })

  set('n', '<leader>lx', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
  set('n', '<leader>ld', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
  set('n', '<leader>lr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'References' })
  set('n', '<leader>li', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
  set('n', '<leader>ly', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
  set('n', '<leader>ls', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })

  set('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = 'Git Log' })
  set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git Status' })
  set('n', '<leader>gf', function() Snacks.lazygit.log_file() end, { desc = 'Lazygit Current File History' })
  set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'Lazygit' })
  set('n', '<leader>gl', function() Snacks.lazygit.log() end, { desc = 'Lazygit Log (cwd)' })
end)

later(function()
  add('hat0uma/csvview.nvim')
  require('csvview').setup()
end)

later(function()
  add('max397574/better-escape.nvim')

  require('better_escape').setup({
    timeout = 160,
    default_mappings = false,
    mappings = {
      i = {
        k = { j = '<Esc>', l = '<Esc>' },
        j = { k = '<Esc>' },
        l = { k = '<Esc>' },
      },
      c = {
        k = { j = '<Esc>', l = '<Esc>' },
        j = { k = '<Esc>' },
        l = { k = '<Esc>' },
      },
      t = {
        k = { j = '<C-\\><C-n>', l = '<C-\\><C-n>' },
        j = { k = '<C-\\><C-n>' },
        l = { k = '<C-\\><C-n>' },
      },
      v = {
        k = { j = '<Esc>', l = '<Esc>' },
        j = { k = '<Esc>' },
        l = { k = '<Esc>' },
      },
      s = {
        k = { j = '<Esc>', l = '<Esc>' },
        j = { k = '<Esc>' },
        l = { k = '<Esc>' },
      },
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
    -- sql = { linters = { 'sqlfluff' } },
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
      local ft = vim.bo[e.buf].filetype
      local conf = linters[ft]

      if conf and (not conf.cond or conf.cond(e.buf)) then require('lint').try_lint(conf.linters) end
    end,
  })
end)

later(function()
  add('nvim-treesitter/nvim-treesitter-textobjects')
  local miniai = require('mini.ai')

  require('mini.ai').setup({
    n_lines = 300,
    custom_textobjects = {
      f = miniai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
      g = function()
        local from = { line = 1, col = 1 }
        local to = {
          line = vim.fn.line('$'),
          col = math.max(vim.fn.getline('$'):len(), 1),
        }
        return { from = from, to = to }
      end,
    },
    silent = true,
    search_method = 'cover',
    mappings = {
      around_next = '',
      inside_next = '',
      around_last = '',
      inside_last = '',
    },
  })
end)

later(function()
  require('mini.files').setup({
    mappings = {
      show_help = '?',
      go_in_plus = '<cr>',
      go_out_plus = '<bs>',
      go_in = '',
      go_out = '',
    },
    windows = { width_nofocus = 25 },
  })

  local map_split = function(buf_id, lhs, direction)
    local minifiles = require('mini.files')

    local function rhs()
      local window = minifiles.get_explorer_state().target_window
      if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then return end

      local new_target_window
      vim.api.nvim_win_call(window, function()
        vim.cmd(direction .. ' split')
        new_target_window = vim.api.nvim_get_current_win()
      end)

      minifiles.set_target_window(new_target_window)
      minifiles.go_in({ close_on_file = true })
    end

    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
  end

  local open = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesWindowOpen',
    callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'rounded' }) end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local buf_id = args.data.buf_id

      map_split(buf_id, '<C-w>s', 'belowright horizontal')
      map_split(buf_id, '<C-w>v', 'belowright vertical')
    end,
  })

  vim.keymap.set('n', '-', open, { desc = 'File explorer' })
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

  vim.keymap.set('n', '<Leader>ia', '<cmd>IronAttach<cr>', { desc = 'Iron Attach' })
  vim.keymap.set('n', '<Leader>ih', '<cmd>IronHide<cr>', { desc = 'Iron Hide' })
  vim.keymap.set('n', '<Leader>io', '<cmd>IronFocus<cr>', { desc = 'Iron Focus' })
  vim.keymap.set('n', '<Leader>ie', '<cmd>IronRepl<cr>', { desc = 'Iron Repl' })
  vim.keymap.set('n', '<Leader>ir', '<cmd>IronRestart<cr>', { desc = 'Iron Restart' })
  vim.keymap.set('n', '<Leader>is', '<cmd>IronSend<cr>', { desc = 'Iron Send' })
end)

later(function()
  add({ source = 'saghen/blink.compat' })

  add({
    source = 'Saghen/blink.cmp',
    hooks = {
      post_checkout = function(params) build(params, { 'cargo', 'build', '--release' }) end,
      post_install = function(params) build(params, { 'cargo', 'build', '--release' }) end,
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

  vim.keymap.set({ 'n', 'v' }, '<Leader>ca', ':CodeCompanionActions<CR>', { desc = 'Actions' })
  vim.keymap.set({ 'n', 'v' }, '<Leader>ct', ':CodeCompanionChat Toggle<CR>', { desc = 'Toggle chat' })
  vim.keymap.set('v', '<Leader>ca', ':CodeCompanionChat Add<CR>', { desc = 'Add to chat' })
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

  local function format(buf)
    require('conform').format({
      bufnr = buf or vim.api.nvim_get_current_buf(),
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = 'fallback',
    })
  end

  Snacks.toggle({
    name = 'Autoformat (conform.nvim)',
    get = function() return vim.g.autoformat end,
    set = function(enabled) vim.g.autoformat = enabled end,
  }):map('<leader>uf')

  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(e)
      if not vim.g.autoformat then return end
      format(e.buf)
    end,
  })

  vim.keymap.set('n', '<Leader>lf', format, { desc = 'Format current buffer' })
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

  local function dap_scopes() require('dap.ui.widgets').sidebar(require('dap.ui.widgets').scopes, {}, 'vsplit').toggle() end

  set('n', '<Leader>dR', '<Cmd>lua require("dap.repl").toggle({}, "belowright split")<CR>', { desc = 'Repl' })
  set('n', '<Leader>db', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', { desc = 'Set breakpoint' })
  set('n', '<Leader>dc', '<Cmd>lua require("dap").clear_breakpoints()<CR>', { desc = 'Clear breakpoints' })
  set('n', '<Leader>de', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { desc = 'Eval' })
  set('n', '<Leader>dr', '<Cmd>lua require("dap").continue()<CR>', { desc = 'Continue' })
  set('n', '<Leader>ds', dap_scopes, { desc = 'Scopes' })
  set('n', '<Leader>dt', '<Cmd>lua require("dap").terminate()<CR>', { desc = 'Terminate' })
  set('n', '<Leader>du', '<Cmd>lua require("dap").run_to_cursor()<CR>', { desc = 'Run to cursor' })
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

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', { clear = true }),
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  })
end)

later(function()
  local miniclue = require('mini.clue')

  miniclue.setup({
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
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
      { mode = 'n', keys = '<Leader>t', desc = '+Tabs' },
      { mode = 'n', keys = '<Leader>u', desc = '+Toggle' },
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
    window = {
      delay = 200,
      config = {
        width = 'auto',
      },
    },
  })
end)
