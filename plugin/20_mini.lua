local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ name = 'mini.nvim' })

now(function()
  require('mini.notify').setup({
    content = {
      sort = function(notif_arr)
        return MiniNotify.default_sort(
          vim.tbl_filter(function(notif) return not vim.startswith(notif.msg, 'lua_ls: Diagnosing') end, notif_arr)
        )
      end,
    },
  })

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
  MiniDeps.later(MiniIcons.tweak_lsp_kind)
end)

now(function() vim.cmd('colorscheme minigrey') end)

later(function() require('mini.extra').setup() end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.doc').setup() end)
later(function() require('mini.operators').setup() end)
later(function() require('mini.visits').setup() end)

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
