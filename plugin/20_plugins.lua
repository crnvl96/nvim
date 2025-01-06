local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local Set, S, LS = Config.Set, Config.S, Config.LS

add({ name = 'mini.nvim' })

now(function() vim.cmd('colorscheme minigrey') end)

later(function() require('mini.extra').setup() end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.doc').setup() end)
later(function() require('mini.operators').setup() end)
later(function() require('mini.visits').setup() end)

later(function()
  S('ba', 'b#', '[B]uffer [A]lternate')
  S('bd', 'bd', '[B]uffer [D]elete')
end)

now(function()
  local function filter(el) return not vim.startswith(el.msg, 'lua_ls: Diagnosing') end

  local function sort(list)
    list = vim.tbl_filter(filter, list)
    return MiniNotify.default_sort(list)
  end

  require('mini.notify').setup({ content = { sort = sort } })

  vim.notify = MiniNotify.make_notify()
end)

now(function()
  require('mini.misc').setup_auto_root()
  require('mini.misc').setup_termbg_sync()
end)

now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })

  MiniIcons.mock_nvim_web_devicons()
  later(MiniIcons.tweak_lsp_kind)
end)

later(function()
  local miniclue = require('mini.clue')

  miniclue.setup({
    clues = {
      { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<Leader>c', desc = '+Code' },
      { mode = 'n', keys = '<Leader>d', desc = '+Debug' },
      { mode = 'n', keys = '<Leader>f', desc = '+Files' },
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'x', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>i', desc = '+IA' },
      { mode = 'x', keys = '<Leader>i', desc = '+IA' },
      { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
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

  Set('n', '-', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
end)

later(function()
  require('mini.pick').setup({
    delay = {
      async = 10,
      busy = 30,
    },
    options = {
      use_cache = true,
    },
    source = {
      items = nil,
      name = nil,
      cwd = nil,

      match = nil,
      preview = nil,
      show = function(buf_id, items, query, opts)
        require('mini.pick').default_show(
          buf_id,
          items,
          query,
          vim.tbl_deep_extend('force', { show_icons = true, icons = {} }, opts or {})
        )
      end,

      choose = nil,
      choose_marked = nil,
    },
    window = {
      config = function()
        local height, width, col, row
        local win_width = vim.o.columns
        local win_height = vim.o.lines

        if win_height <= 25 then
          height = math.min(win_height, 18)
          width = win_width
          col = 1
          row = win_height
        else
          width = math.floor(win_width * 0.618)
          height = math.floor(win_height * 0.618)
          col = math.floor(0.5 * (vim.o.columns - width))
          row = math.floor(0.5 * (vim.o.lines - height))
        end

        return {
          col = col,
          row = row,
          height = height,
          width = width,
          anchor = 'NW',
          style = 'minimal',
          border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
        }
      end,

      prompt_cursor = '|',
      prompt_prefix = '',
    },
    mappings = {
      caret_left = '<Left>',
      caret_right = '<Right>',

      choose = '<CR>',
      choose_in_split = '<C-s>',
      choose_in_tabpage = '<C-t>',
      choose_in_vsplit = '<C-v>',
      choose_marked = '<C-CR>',

      delete_char = '<BS>',
      delete_char_right = '<S-BS>',
      delete_left = '<A-BS>',
      delete_word = '<C-w>',

      mark = '<C-x>',
      mark_all = '<C-a>',

      move_start = '<C-g>',
      move_down = '<C-n>',
      move_up = '<C-p>',

      paste = '<A-p>',

      refine = '<C-Space>',
      refine_marked = '<M-Space>',

      scroll_up = '<C-u>',
      scroll_down = '<C-d>',
      scroll_left = '<C-h>',
      scroll_right = '<C-l>',

      stop = '<Esc>',

      toggle_info = '<S-Tab>',
      toggle_preview = '<Tab>',
    },
  })

  vim.ui.select = MiniPick.ui_select

  local highlight = vim.api.nvim_set_hl

  highlight(0, 'MiniPickBorder', { link = 'Pmenu' })
  highlight(0, 'MiniPickBorderBusy', { link = 'Pmenu' })
  highlight(0, 'MiniPickBorderText', { link = 'Pmenu' })
  highlight(0, 'MiniPickIconDirectory', { link = 'Pmenu' })
  highlight(0, 'MiniPickIconFile', { link = 'Pmenu' })
  highlight(0, 'MiniPickNormal', { link = 'Pmenu' })
  highlight(0, 'MiniPickHeader', { link = 'Title' })
  highlight(0, 'MiniPickMatchCurrent', { link = 'PmenuThumb' })
  highlight(0, 'MiniPickMatchMarked', { link = 'FloatTitle' })
  highlight(0, 'MiniPickMatchRanges', { link = 'Title' })
  highlight(0, 'MiniPickPreviewLine', { link = 'PmenuThumb' })
  highlight(0, 'MiniPickPreviewRegion', { link = 'PmenuThumb' })
  highlight(0, 'MiniPickPrompt', { link = 'Pmenu' })

  MiniPick.registry.multigrep = function()
    local process
    local symbol = '::'
    local set_items_opts = { do_match = false }
    local spawn_opts = { cwd = vim.uv.cwd() }

    local match = function(_, _, query)
      pcall(vim.loop.process_kill, process)
      if #query == 0 then return MiniPick.set_picker_items({}, set_items_opts) end
      local full_query = table.concat(query)
      local parts = vim.split(full_query, symbol, { plain = true })

      -- First part is always the search pattern
      local search_pattern = parts[1] and parts[1] ~= '' and parts[1] or nil

      local command = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
      }

      -- Add search pattern if exists
      if search_pattern then
        table.insert(command, '-e')
        table.insert(command, search_pattern)
      end

      -- Process file patterns
      local include_patterns = {}
      local exclude_patterns = {}

      for i = 2, #parts do
        local pattern = parts[i]
        if pattern:sub(1, 1) == '!' then
          table.insert(exclude_patterns, pattern:sub(2))
        else
          table.insert(include_patterns, pattern)
        end
      end

      if #include_patterns > 0 then
        for _, pattern in ipairs(include_patterns) do
          table.insert(command, '-g')
          table.insert(command, pattern)
        end
      end

      if #exclude_patterns > 0 then
        for _, pattern in ipairs(exclude_patterns) do
          table.insert(command, '-g')
          table.insert(command, '!' .. pattern)
        end
      end

      process = MiniPick.set_picker_items_from_cli(command, {
        postprocess = function(lines)
          local results = {}
          for _, line in ipairs(lines) do
            if line ~= '' then
              local file, lnum, col = line:match('([^:]+):(%d+):(%d+):(.*)')
              if file then
                results[#results + 1] = {
                  path = file,
                  lnum = tonumber(lnum),
                  col = tonumber(col),
                  text = line,
                }
              end
            end
          end
          return results
        end,
        set_items_opts = set_items_opts,
        spawn_opts = spawn_opts,
      })
    end

    return MiniPick.start({
      source = {
        items = {},
        name = 'Multi Grep',
        match = match,
        show = function(buf_id, items_to_show, query)
          MiniPick.default_show(buf_id, items_to_show, query, { show_icons = true })
        end,
        choose = MiniPick.default_choose,
      },
    })
  end
end)

later(function() add({ source = 'nvim-lua/plenary.nvim' }) end)
later(function() add({ source = 'lambdalisue/vim-suda' }) end)
later(function() add({ source = 'mechatroner/rainbow_csv' }) end)
later(function() add({ source = 'HakonHarnes/img-clip.nvim' }) end)
later(function() add({ source = 'mfussenegger/nvim-lint' }) end)
later(function() add({ source = 'tpope/vim-fugitive' }) end)

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

  later(function()
    local mr = require('mason-registry')

    mr.refresh(function()
      for _, tool in ipairs(Mason_tools) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })

  require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    indent = {
      enable = true,
    },
    sync_install = false,
    auto_install = true,
    ensure_installed = Treesitter_parsers,
  })
end)

later(function()
  add({ source = 'saghen/blink.compat' })
  add({ source = 'xzbdmw/colorful-menu.nvim' })
  add({
    source = 'Saghen/blink.cmp',
    hooks = {
      post_checkout = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
      post_install = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
    },
  })

  require('blink.compat').setup()
  require('colorful-menu').setup()

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
      list = { selection = function(ctx) return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect' end },
      menu = {
        border = 'single',
        scrollbar = false,
        -- auto_show = function(ctx) return ctx.mode ~= 'cmdline' end,
        draw = {
          treesitter = { 'lsp' },
          columns = { { 'kind_icon' }, { 'label', gap = 1 } },
          components = {
            label = {
              text = require('colorful-menu').blink_components_text,
              highlight = require('colorful-menu').blink_components_highlight,
            },
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
      transform_items = function(_, items)
        return vim.tbl_filter(
          function(item) return item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet end,
          items
        )
      end,

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

  --- Retrieve a LLM (in this case, from anthropic) from a local file, and returns it
  --- to be integrated with relevant plugins.
  ---
  --- This is done this way to avoid exposing the private key in the running shell session via environment keys.
  ---@return string?
  local function retrieve_llm_key()
    ---@type string
    local path = vim.fn.stdpath('config') .. '/anthropic'
    ---@type file*?
    local file = io.open(path, 'r')
    ---@type string?
    local key

    if file then
      ---@type string?
      key = file:read('*a'):gsub('%s+$', '')
      file:close()
    end

    return key or nil
  end

  local key = retrieve_llm_key()

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
  require('conform').setup({
    notify_on_error = true,
    formatters_by_ft = Formatters.by_ft,
    formatters = Formatters.specs,
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

  for server, config in pairs(Servers) do
    config = vim.tbl_deep_extend('force', config or {}, { capabilities = capabilities })
    require('lspconfig')[server].setup(config)
  end
end)

later(function()
  add({ source = 'theHamsta/nvim-dap-virtual-text' })
  add({ source = 'mfussenegger/nvim-dap' })

  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
  require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })

  local function json_decode(data)
    local decode = vim.json.decode
    local strip_comments = require('plenary.json').json_strip_comments
    data = strip_comments(data)

    return decode(data)
  end

  require('dap.ext.vscode').json_decode = json_decode

  Debuggers_by_ft()
end)
