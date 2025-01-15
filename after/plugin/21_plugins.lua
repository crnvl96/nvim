Now(function()
  Add({ source = 'williamboman/mason.nvim', hooks = { post_checkout = function() vim.cmd('MasonUpdate') end } })
  require('mason').setup()
  Later(function()
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

Now(function()
  require('mini.icons').setup()
  require('mini.doc').setup()
  require('mini.align').setup()
  require('mini.splitjoin').setup()
  require('mini.operators').setup()
  require('mini.diff').setup()
end)

Now(function()
  Add('nvim-lua/plenary.nvim')
  Add('tpope/vim-sleuth')
  Add('lambdalisue/vim-suda')
  Add('tpope/vim-fugitive')
  Add('tpope/vim-rhubarb')

  local function fzf_install()
    Later(function() vim.fn['fzf#install']() end)
  end

  Add({
    source = 'junegunn/fzf',
    hooks = {
      post_checkout = fzf_install,
      post_install = fzf_install,
    },
  })
end)

Now(function()
  Add({
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

Now(function()
  Add('folke/snacks.nvim')

  require('snacks').setup({
    bigfile = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    picker = {
      layout = {
        cycle = true,
        preset = 'ivy',
      },
      win = {
        input = {
          keys = {
            ['<Esc>'] = 'close',
            ['<CR>'] = 'confirm',
            ['G'] = 'list_bottom',
            ['gg'] = 'list_top',
            ['j'] = 'list_down',
            ['k'] = 'list_up',
            ['/'] = 'toggle_focus',
            ['q'] = 'close',
            ['?'] = 'toggle_help',
            ['<a-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
            ['<a-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
            ['<a-w>'] = { 'cycle_win', mode = { 'i', 'n' } },
            ['<C-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },
            ['<C-Up>'] = { 'history_back', mode = { 'i', 'n' } },
            ['<C-Down>'] = { 'history_forward', mode = { 'i', 'n' } },
            ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
            ['<S-Tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
            ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },
            ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
            ['<c-j>'] = { 'list_down', mode = { 'i', 'n' } },
            ['<c-k>'] = { 'list_up', mode = { 'i', 'n' } },
            ['<c-n>'] = { 'list_down', mode = { 'i', 'n' } },
            ['<c-p>'] = { 'list_up', mode = { 'i', 'n' } },
            ['<c-b>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
            ['<c-d>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
            ['<c-f>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
            ['<c-g>'] = { 'toggle_live', mode = { 'i', 'n' } },
            ['<c-u>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
            ['<ScrollWheelDown>'] = { 'list_scroll_wheel_down', mode = { 'i', 'n' } },
            ['<ScrollWheelUp>'] = { 'list_scroll_wheel_up', mode = { 'i', 'n' } },
            ['<c-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
            ['<c-s>'] = { 'edit_split', mode = { 'i', 'n' } },
            ['<c-q>'] = { 'qflist', mode = { 'i', 'n' } },
            ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
            ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
          },
          b = {
            minipairs_disable = true,
          },
        },
        list = {
          keys = {
            ['<CR>'] = 'confirm',
            ['gg'] = 'list_top',
            ['G'] = 'list_bottom',
            ['i'] = 'focus_input',
            ['j'] = 'list_down',
            ['k'] = 'list_up',
            ['q'] = 'close',
            ['<Tab>'] = 'select_and_next',
            ['<S-Tab>'] = 'select_and_prev',
            ['<Down>'] = 'list_down',
            ['<Up>'] = 'list_up',
            ['<c-d>'] = 'list_scroll_down',
            ['<c-u>'] = 'list_scroll_up',
            ['zt'] = 'list_scroll_top',
            ['zb'] = 'list_scroll_bottom',
            ['zz'] = 'list_scroll_center',
            ['/'] = 'toggle_focus',
            ['<ScrollWheelDown>'] = 'list_scroll_wheel_down',
            ['<ScrollWheelUp>'] = 'list_scroll_wheel_up',
            ['<c-f>'] = 'preview_scroll_down',
            ['<c-b>'] = 'preview_scroll_up',
            ['<c-v>'] = 'edit_vsplit',
            ['<c-s>'] = 'edit_split',
            ['<c-j>'] = 'list_down',
            ['<c-k>'] = 'list_up',
            ['<c-n>'] = 'list_down',
            ['<c-p>'] = 'list_up',
            ['<a-w>'] = 'cycle_win',
            ['<Esc>'] = 'close',
          },
        },
        preview = {
          keys = {
            ['<Esc>'] = 'close',
            ['q'] = 'close',
            ['i'] = 'focus_input',
            ['<ScrollWheelDown>'] = 'list_scroll_wheel_down',
            ['<ScrollWheelUp>'] = 'list_scroll_wheel_up',
            ['<a-w>'] = 'cycle_win',
          },
        },
      },
    },
  })

  local set = vim.keymap.set

  set('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Buffers' })

  set('n', '<leader>fg', function()
    Snacks.picker.grep({
      hidden = true,
    })
  end, { desc = 'Grep' })

  set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find Files' })
  set('n', '<leader>fo', function() Snacks.picker.recent() end, { desc = 'Recent' })
  set('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = 'Git Log' })
  set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git Status' })
  set('n', '<leader>fl', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
  set('n', '<leader>lx', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
  set('n', '<leader>fh', function() Snacks.picker.help() end, { desc = 'Help Pages' })
  set('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
  set('n', '<leader>fr', function() Snacks.picker.resume() end, { desc = 'Resume' })
  set('n', '<leader>fx', function() Snacks.picker.qflist() end, { desc = 'Quickfix List' })
  set('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Projects' })
  set('n', '<leader>fz', function() Snacks.picker.zoxide() end, { desc = 'Z' })
  -- LSP
  set('n', '<leader>ld', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
  set('n', '<leader>lr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'References' })
  set('n', '<leader>li', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
  set('n', '<leader>ly', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
  set('n', '<leader>ls', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
end)

Later(function()
  Add('hat0uma/csvview.nvim')
  require('csvview').setup()
end)

Later(function()
  Add({ source = 'mfussenegger/nvim-lint' })

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
      local buf = e.buf
      local ft = vim.bo[buf].filetype
      local conf = linters[ft]
      if conf and (not conf.cond or conf.cond(buf)) then require('lint').try_lint(conf.linters) end
    end,
  })
end)

Later(function()
  Add('stevearc/oil.nvim')

  function _G.get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local dir = require('oil').get_current_dir(bufnr)
    if dir then
      return vim.fn.fnamemodify(dir, ':~')
    else
      return vim.api.nvim_buf_get_name(0)
    end
  end

  require('oil').setup({
    watch_for_changes = true,
    win_options = {
      winbar = '%!v:lua.get_oil_winbar()',
    },
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-w>v'] = { 'actions.select', opts = { vertical = true } },
      ['<C-w>s'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-w>t'] = { 'actions.select', opts = { tab = true } },
      ['<f4>'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['<f5>'] = 'actions.refresh',
      ['-'] = { 'actions.parent', mode = 'n' },
      ['@'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
    use_default_keymaps = false,
    view_options = { show_hidden = true },
    float = { border = 'single' },
    confirmation = { border = 'single' },
    progress = { border = 'single' },
    ssh = { border = 'single' },
    keymaps_help = { border = 'single' },
  })

  vim.keymap.set('n', '-', require('oil').open)
end)

Later(function()
  Add({ source = 'kevinhwang91/nvim-bqf' })

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
      tabc = '<C-w>t',
      split = '<C-w>s',
      vsplit = '<C-w>v',
    },
    filter = {
      fzf = {
        action_for = { ['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop' },
        extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ', '--delimiter', '│' },
      },
    },
  })
end)

Later(function()
  Add({ source = 'Vigemus/iron.nvim' })

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

Later(function()
  Add({ source = 'saghen/blink.compat' })

  Add({
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

Later(function()
  Add({ source = 'olimorris/codecompanion.nvim' })

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

  vim.keymap.set({ 'n', 'v' }, '<Leader>ca', '<Cmd>CodeCompanionActions<CR>', { desc = 'Actions' })
  vim.keymap.set({ 'n', 'v' }, '<Leader>ct', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle chat' })
  vim.keymap.set('v', 'ga', '<Cmd>CodeCompanionChat Add<CR>', { desc = 'Add to chat' })
end)

Later(function()
  Add({ source = 'stevearc/conform.nvim' })

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  vim.g.autoformat = true

  require('conform').setup({
    notify_on_error = true,
    formatters_by_ft = {
      markdown = { 'prettierd', 'injected' },
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

  local function toggle_format()
    local state = vim.g.autoformat
    vim.g.autoformat = not state

    vim.notify((vim.g.autoformat and 'Enabled' or 'Disabled') .. ' format on save', vim.log.levels.INFO)
  end

  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(e)
      if not vim.g.autoformat then return end
      format(e.buf)
    end,
  })

  vim.keymap.set('n', '<Leader>uf', toggle_format, { desc = 'Toggle format on save' })
  vim.keymap.set('n', '<Leader>lf', format, { desc = 'Format current buffer' })
end)

Later(function()
  Add({ source = 'theHamsta/nvim-dap-virtual-text' })
  Add({ source = 'mfussenegger/nvim-dap' })
  Add({ source = 'mfussenegger/nvim-dap-python' })

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
  local set = vim.keymap.set

  set('n', '<Leader>dR', '<Cmd>lua require("dap.repl").toggle({}, "belowright split")<CR>', { desc = 'Repl' })
  set('n', '<Leader>db', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', { desc = 'Set breakpoint' })
  set('n', '<Leader>dc', '<Cmd>lua require("dap").clear_breakpoints()<CR>', { desc = 'Clear breakpoints' })
  set('n', '<Leader>de', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { desc = 'Eval' })
  set('n', '<Leader>dr', '<Cmd>lua require("dap").continue()<CR>', { desc = 'Continue' })
  set('n', '<Leader>ds', dap_scopes, { desc = 'Scopes' })
  set('n', '<Leader>dt', '<Cmd>lua require("dap").terminate()<CR>', { desc = 'Terminate' })
  set('n', '<Leader>du', '<Cmd>lua require("dap").run_to_cursor()<CR>', { desc = 'Run to cursor' })
end)

Later(function()
  Add({ source = 'neovim/nvim-lspconfig' })

  local servers = {
    vtsls = require('plugins.lsp.servers.vtsls'),
    basedpyright = require('plugins.lsp.servers.basedpyright'),
    lua_ls = require('plugins.lsp.servers.lua_ls'),
  }

  for server, config in pairs(servers) do
    config = config or {}
    local opts = { capabilities = require('plugins.lsp.capabilities') }
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

Later(function()
  local miniclue = require('mini.clue')

  miniclue.setup({
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
      require('plugins.mini-clue.clues'),
    },
    triggers = require('plugins.mini-clue.triggers'),
    window = {
      delay = 200,
      config = {
        width = 'auto',
      },
    },
  })
end)
