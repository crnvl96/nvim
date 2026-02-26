Config.now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
    file = {
      ['.eslintrc.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
      ['.node-version'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['.prettierrc'] = { glyph = '', hl = 'MiniIconsPurple' },
      ['.yarnrc.yml'] = { glyph = '', hl = 'MiniIconsBlue' },
      ['eslint.config.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
      ['package.json'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
      ['tsconfig.build.json'] = { glyph = '', hl = 'MiniIconsAzure' },
      ['yarn.lock'] = { glyph = '', hl = 'MiniIconsBlue' },
      ['.go-version'] = { glyph = '', hl = 'MiniIconsBlue' },
    },
    filetype = {
      gotmpl = { glyph = '󰟓', hl = 'MiniIconsGrey' },
    },
  })
  Config.later(MiniIcons.tweak_lsp_kind)
  Config.later(MiniIcons.mock_nvim_web_devicons)
end)

Config.later(function() require('mini.extra').setup() end)
Config.later(function() require('mini.visits').setup() end)
Config.later(function() require('mini.align').setup() end)
Config.later(function() require('mini.operators').setup() end)
Config.later(function() require('mini.move').setup() end)
Config.later(function() require('mini.surround').setup() end)
Config.later(function() require('mini.splitjoin').setup() end)
Config.later(function() require('mini.cmdline').setup() end)
Config.later(function() require('mini.bracketed').setup() end)
Config.later(function() require('mini.statusline').setup() end)
Config.later(function() require('mini.tabline').setup() end)
Config.later(function() require('mini.git').setup() end)
Config.later(function() require('mini.diff').setup({ view = { style = 'sign' } }) end)
Config.later(function() require('mini.indentscope').setup({ options = { border = 'top', try_as_border = true } }) end)

Config.now(function()
  vim.cmd.colorscheme('miniwinter')
  require('mini.colors').get_colorscheme():add_transparency({ general = false, float = true }):apply()
end)

Config.later(function()
  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        return MiniCompletion.default_process_items(items, base, { kind_priority = { Text = -1, Snippet = -1 } })
      end,
    },
  })
  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = Config.gr,
    callback = function(e) vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
  })
end)

Config.later(
  function()
    require('mini.hipatterns').setup({
      highlighters = { hex_color = require('mini.hipatterns').gen_highlighter.hex_color() },
    })
  end
)

Config.later(
  function()
    require('mini.jump2d').setup({
      spotter = require('mini.jump2d').gen_spotter.pattern('[^%s%p]+'),
      labels = 'asdfghjklweruioxcvn,.',
      view = { dim = true, n_steps_ahead = 2 },
    })
  end
)

Config.later(function()
  require('mini.pairs').setup({
    modes = { insert = true, command = true, terminal = false },
  })
  local pairs = require('mini.pairs')
  local open = pairs.open
  pairs.open = function(pair, neigh_pattern)
    if vim.fn.getcmdline() ~= '' then return open(pair, neigh_pattern) end
    local o, c = pair:sub(1, 1), pair:sub(2, 2)
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local next = line:sub(cursor[2] + 1, cursor[2] + 1)
    local before = line:sub(1, cursor[2])
    if o == '`' and vim.bo.filetype == 'markdown' and before:match('^%s*``') then
      return '`\n```' .. vim.api.nvim_replace_termcodes('<up>', true, true, true)
    end
    if next ~= '' and next:match([=[[%w%%%'%[%"%.%`%$]]=]) then return o end
    local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
    for _, capture in ipairs(ok and captures or {}) do
      if vim.tbl_contains({ 'string' }, capture.capture) then return o end
    end
    if next == c and c ~= o then
      local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), '')
      local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), '')
      if count_close > count_open then return o end
    end
    return open(pair, neigh_pattern)
  end
end)

Config.later(function()
  require('mini.ai').setup({
    search_method = 'cover',
    custom_textobjects = {
      g = MiniExtra.gen_ai_spec.buffer(),
      f = require('mini.ai').gen_spec.treesitter({ -- functions
        a = '@function.outer',
        i = '@function.inner',
      }),
      o = require('mini.ai').gen_spec.treesitter({ -- code block
        a = { '@block.outer', '@conditional.outer', '@loop.outer' },
        i = { '@block.inner', '@conditional.inner', '@loop.inner' },
      }),
      t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
      d = { '%f[%d]%d+' }, -- digits
      e = { -- Word with case
        { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
        '^().*()$',
      },
    },
  })
end)

Config.later(function()
  require('mini.keymap').setup()
  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept' })
end)

Config.later(function()
  Config.show_dotfiles = true
  require('mini.files').setup({ mappings = { go_in = '', go_in_plus = '<CR>', go_out = '', go_out_plus = '-' } })
  local filter_show = function() return true end
  local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, '.') end
  local toggle_dotfiles = function()
    Config.show_dotfiles = not Config.show_dotfiles
    local new_filter = Config.show_dotfiles and filter_show or filter_hide
    MiniFiles.refresh({ content = { filter = new_filter } })
  end
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local buf_id = args.data.buf_id
      vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesExplorerOpen',
    group = Config.gr,
    callback = function()
      MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
      MiniFiles.set_bookmark('p', vim.fn.stdpath('data') .. '/site/pack/core/opt', { desc = 'Plugins' })
      MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working directory' })
      MiniFiles.set_bookmark('n', vim.env.HOME .. '/Developer/personal/notes', { desc = 'Notes' })
      MiniFiles.set_bookmark('d', vim.env.HOME .. '/Developer', { desc = 'Projects' })
      MiniFiles.set_bookmark('h', vim.env.HOME, { desc = 'Home' })
    end,
  })
end)

Config.later(function()
  require('mini.pick').setup({ window = { prompt_prefix = ' ' } })
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(
      items,
      opts,
      on_choice,
      { window = { config = { relative = 'cursor', anchor = 'NW', row = 0, col = 0, width = 80, height = 15 } } }
    )
  end
end)

Config.later(
  function()
    require('mini.clue').setup({
      triggers = {
        { mode = 'n', keys = '\\' },
        { mode = 'i', keys = '<C-x>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = { 'n', 'x' }, keys = '<Leader>' },
        { mode = { 'n', 'x' }, keys = '[' },
        { mode = { 'n', 'x' }, keys = ']' },
        { mode = { 'n', 'x' }, keys = 'g' },
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },
        { mode = { 'n', 'x' }, keys = 'z' },
      },
      clues = {
        Config.clues,
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.square_brackets(),
        require('mini.clue').gen_clues.windows(),
        require('mini.clue').gen_clues.z(),
      },
      window = { delay = 500, scroll_down = '<C-f>', scroll_up = '<C-b>', config = { width = 'auto' } },
    })
  end
)
