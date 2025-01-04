_G.Config = {}
_G.Lang = {}
_G.Plugin = {}

local H = {}

function Plugin.mininotify_opts()
  return {
    content = {
      sort = function(notif_arr)
        return MiniNotify.default_sort(
          vim.tbl_filter(function(notif) return not vim.startswith(notif.msg, 'lua_ls: Diagnosing') end, notif_arr)
        )
      end,
    },
  }
end

function Plugin.miniicons_opts()
  return {
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  }
end

function Plugin.miniclue_opts()
  local miniclue = require('mini.clue')

  return {
    clues = {
      Config.clues(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = Config.triggers(),
    window = { delay = 200, config = { width = 'auto' } },
  }
end

function Plugin.minifiles_opts()
  return {
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
    },
    windows = { width_nofocus = 25, preview = true, width_preview = 50 },
    options = { permanent_delete = false },
  }
end

function Plugin.minipick_opts()
  return {
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
        local height, width, starts, ends
        local win_width = vim.o.columns
        local win_height = vim.o.lines

        if win_height <= 25 then
          height = math.min(win_height, 18)
          width = win_width
          starts = 1
          ends = win_height
        else
          width = math.floor(win_width * 0.5) -- 50%
          height = math.floor(win_height * 0.3) -- 30%
          starts = math.floor((win_width - width) / 2)
          -- center prompt: height * (50% + 30%)
          -- center window: height * [50% + (30% / 2)]
          ends = math.floor(win_height * 0.65)
        end

        return {
          col = starts,
          row = ends,
          height = height,
          width = width,
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

      send_to_qflist = {
        char = '<C-q>',
        func = function() vim.fn.setqflist(H.minipick_parse_matches(), 'r') end,
      },
    },
  }
end

function Plugin.treesitter_opts()
  return {
    highlight = {
      enable = true,
      disable = function(_, buf) return vim.tbl_contains({ 'tex' }, vim.bo[buf].filetype) end,
    },
    indent = {
      enable = true,
    },
    sync_install = false,
    auto_install = true,
    ensure_installed = Lang.treesitter_parsers_by_ft(),
  }
end

function Plugin.blink_opts()
  return {
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
          treesitter = { 'lsp' },
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
  }
end

function Plugin.codecompanion_opts()
  local key = Config.retrieve_llm_key()

  if not key then
    vim.notify('An `anthropic` key must be set for a proper config setup', vim.log.levels.ERROR)
    return
  end

  return {
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
  }
end

function Plugin.conform_opts()
  local formatters_by_ft = Lang.formatters_by_ft()
  local formatters = Lang.formatters_settings()

  return {
    notify_on_error = true,
    formatters_by_ft = formatters_by_ft,
    formatters = formatters,
  }
end

function Config.minipick_set_hls()
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
end

function Config.extend(b, n)
  local base = vim.deepcopy(b or {})
  local new = vim.deepcopy(n or {})
  if H.is_array(base) and H.is_array(new) then return vim.list_extend(base, new) end
  return H.merge(base, new)
end

function Config.check_cli_requirements()
  local tools = {
    'zathura',
    'tex-fmt',
    'tree-sitter',
    'rg',
    'rustc',
    'npm',
  }

  for _, cli in ipairs(tools) do
    if vim.fn.executable(cli) ~= 1 then
      local msg = cli .. ' is not installed in the system.'
      local lvl = vim.log.levels.ERROR

      vim.notify(msg, lvl)
    end
  end
end

function Config.json_decode(data)
  local decode = vim.json.decode
  local strip_comments = require('plenary.json').json_strip_comments
  data = strip_comments(data)

  return decode(data)
end

--- Retrieve a LLM (in this case, from anthropic) from a local file, and returns it
--- to be integrated with relevant plugins.
---
--- This is done this way to avoid exposing the private key in the running shell session via environment keys.
---@return string?
function Config.retrieve_llm_key()
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

---@return string?
function Config.get_install_path(tool)
  local path = require('mason-registry').get_package(tool):get_install_path()
  return path or nil
end

---@class LinterConfig
---@field cond? fun(buf: number): boolean
---@field linters string[]

--- Returns a list of linters grouped by the filetype they should run on
---@return table<string, LinterConfig>
function Lang.linters_by_ft()
  return {
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
end

function Lang.formatters_by_ft()
  return {
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
  }
end

function Lang.formatters_settings()
  return {
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
  }
end

function Lang.treesitter_parsers_by_ft()
  return {
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
  }
end

function Lang.setup_lsp_servers()
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
  })
end

function Lang.setup_lang_servers()
  ---
  --- Python debug adapter
  ---
  local debugpy_path = Config.get_install_path('debugpy')

  if not debugpy_path then
    vim.notify('You need to install `debugpy` for dap to work properly', vim.log.levels.ERROR)
    return
  end

  require('dap-python').setup(debugpy_path .. '/venv/bin/python')
end

function Config.toggle_quickfix()
  local quickfix_wins = vim.tbl_filter(
    function(win_id) return vim.fn.getwininfo(win_id)[1].quickfix == 1 end,
    vim.api.nvim_tabpage_list_wins(0)
  )

  local command = #quickfix_wins == 0 and 'copen' or 'cclose'
  vim.cmd(command)
end

function Config.capabilities()
  local ok = pcall(require, 'blink.cmp')
  local default = vim.lsp.protocol.make_client_capabilities()

  if not ok then
    vim.notify('blink.cmp must be installed to have access to full capabilities.', vim.log.levels.ERROR)
    return default
  end

  return require('blink.cmp').get_lsp_capabilities(vim.tbl_deep_extend('force', default, {
    textDocument = { completion = { completionItem = { snippetSupport = false } } },
  }))
end

function Config.on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  Config.on_attach_maps(bufnr)
end

function Config.clues()
  return {
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
  }
end

function Config.triggers()
  return {
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
  }
end

function Config.multigrep()
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
end

function Config.build(params, build_cmd)
  vim.notify('Building ' .. params.name, vim.log.levels.INFO)
  local obj = vim.system(build_cmd, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building ' .. params.name .. ' done', vim.log.levels.INFO)
  else
    vim.notify('Building ' .. params.name .. ' failed', vim.log.levels.ERROR)
  end
end

function Lang.refresh_mason_registry()
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

      -- LaTex
      'tectonic',
    }) do
      local p = mr.get_package(tool)
      if not p:is_installed() then p:install() end
    end
  end)
end

--- Checks if a lua table is an array or not
---@param t table
---@return boolean
function H.is_array(t)
  for i, _ in pairs(t) do
    if type(i) ~= 'number' then return false end
  end

  return true
end

function H.merge(dest, src)
  for k, v in pairs(src) do
    local tgt = rawget(dest, k)

    if type(v) == 'table' and type(tgt) == 'table' then
      if H.is_array(v) and H.is_array(tgt) then
        dest[k] = vim.list_extend(vim.deepcopy(tgt), v)
      else
        H.merge(tgt, v)
      end
    else
      dest[k] = vim.deepcopy(v)
    end
  end

  return dest
end

function H.minipick_parse_matches()
  local list = {}
  local matches = require('mini.pick').get_picker_matches().all

  for _, match in ipairs(matches) do
    if type(match) == 'table' then
      table.insert(list, match)
    else
      local path, lnum, col, search = string.match(match, '(.-)%z(%d+)%z(%d+)%z%s*(.+)')
      local text = path and string.format('%s [%s:%s]  %s', path, lnum, col, search)
      local filename = path or vim.trim(match):match('%s+(.+)')

      table.insert(list, {
        filename = filename or match,
        lnum = lnum or 1,
        col = col or 1,
        text = text or match,
      })
    end
  end

  return list
end
