Config.now(function()
  vim.pack.add({ 'https://github.com/nvim-lua/plenary.nvim' })
end)

Config.later(function()
  require('mini.colors').setup()

  MiniColors.get_colorscheme()
    :add_transparency({
      general = false,
      float = true,
    })
    :apply()
end)

Config.later(function()
  require('mini.bufremove').setup()

  local function wipeout_all_buffers()
    local current_buffer = vim.api.nvim_get_current_buf()
    vim
      .iter(vim.api.nvim_list_bufs())
      :filter(function(bufnr)
        return bufnr ~= current_buffer
          and not vim.bo[bufnr].filetype:find('^snacks_terminal')
      end)
      :each(function(bufnr)
        MiniBufremove.wipeout(bufnr, true)
      end)
  end

  vim.keymap.set(
    'n',
    '<Leader>bo',
    wipeout_all_buffers,
    { desc = 'Wipeout Other Buffers' }
  )
end)

Config.later(function()
  require('mini.diff').setup()

  local function toggle_overlay()
    MiniDiff.toggle_overlay()
  end

  vim.keymap.set(
    'n',
    '<Leader>go',
    toggle_overlay,
    { desc = 'Toggle git diff overlay' }
  )
end)

Config.now(function()
  require('mini.icons').setup({
    -- rely on `vim.filetype.match` for these extensions
    use_file_extension = function(ext, _)
      local suf_3, suf_4 = ext:sub(-3), ext:sub(-4)
      return suf_3 ~= 'scm'
        and suf_3 ~= 'txt'
        and suf_3 ~= 'yml'
        and suf_4 ~= 'json'
        and suf_4 ~= 'yaml'
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

Config.later(function()
  require('mini.indentscope').setup()

  vim.api.nvim_create_autocmd('FileType', {
    group = Config.gr,
    pattern = { 'snacks_terminal', 'terminal' },
    callback = function(e)
      vim.b[e.buf].miniindentscope_disable = true
    end,
  })
end)

Config.later(function()
  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        local default = MiniCompletion.default_process_items
        return default(
          items,
          base,
          { kind_priority = { Text = -1, Snippet = -1 } }
        )
      end,
    },
  })

  vim.lsp.config('*', {
    capabilities = MiniCompletion.get_lsp_capabilities(),
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = Config.gr,
    callback = function(e)
      vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end,
  })
end)

Config.later(function()
  require('mini.hipatterns').setup({
    highlighters = {
      hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    },
  })
end)

Config.later(function()
  require('mini.jump2d').setup({
    spotter = require('mini.jump2d').gen_spotter.pattern('[^%s%p]+'),
    labels = 'asdfghjklweruioxcvn,.',
    view = { dim = true, n_steps_ahead = 2 },
  })
end)

Config.later(function()
  require('mini.pairs').setup({
    modes = {
      insert = true,
      command = true,
      terminal = false,
    },
  })
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
      t = { -- tags
        '<([%p%w]-)%f[^<%w][^<>]->.-</%1>',
        '^<.->().*()</[^/]->$',
      },
      d = { -- digits
        '%f[%d]%d+',
      },
      e = { -- Word with case
        {
          '%u[%l%d]+%f[^%l%d]',
          '%f[%S][%l%d]+%f[^%l%d]',
          '%f[%P][%l%d]+%f[^%l%d]',
          '^[%l%d]+%f[^%l%d]',
        },
        '^().*()$',
      },
    },
  })
end)

Config.later(function()
  require('mini.keymap').setup()

  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
  MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })
  MiniKeymap.map_multistep('i', '<Tab>', {
    'minisnippets_next',
    'minisnippets_expand',
    'pmenu_next',
    'jump_after_tsnode',
    'jump_after_close',
  })
  MiniKeymap.map_multistep('i', '<S-Tab>', {
    'minisnippets_prev',
    'pmenu_prev',
    'jump_before_tsnode',
    'jump_before_open',
  })
end)

Config.later(function()
  local snippets, config_path =
    require('mini.snippets'), vim.fn.stdpath('config')

  snippets.setup({
    snippets = {
      snippets.gen_loader.from_file(config_path .. '/snippets/global.json'),
      snippets.gen_loader.from_lang({
        lang_patterns = {
          tsx = { 'jsx.json' },
          javascriptreact = { 'jsx.json' },
          typescriptreact = { 'jsx.json' },
          markdown_inline = { 'markdown.json' },
        },
      }),
    },
  })
end)

Config.later(function()
  require('mini.files').setup({
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
    },
    windows = {
      max_number = 1,
      preview = false,
      width_focus = math.floor(vim.o.columns * 1),
      width_nofocus = math.floor(vim.o.columns * 0.59),
      width_preview = math.floor(vim.o.columns * 0.59),
    },
  })

  local filter_show = function()
    return true
  end
  local filter_hide = function(fs_entry)
    return not vim.startswith(fs_entry.name, '.')
  end

  local show_dotfiles = true
  local show_preview = false

  local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    MiniFiles.refresh({ content = { filter = new_filter } })
  end

  local toggle_preview = function()
    show_preview = not show_preview
    MiniFiles.refresh({
      windows = {
        max_number = show_preview and 2 or 1,
        preview = show_preview and true or false,
        width_focus = math.floor(vim.o.columns * (show_preview and 0.39 or 1)),
      },
    })
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(e)
      local buf_id = e.data.buf_id
      vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
      vim.keymap.set('n', 'gp', toggle_preview, { buffer = buf_id })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesExplorerClose',
    group = Config.gr,
    callback = function()
      show_dotfiles = true
      show_preview = false
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesActionRename',
    callback = function(e)
      Snacks.rename.on_rename_file(e.data.from, e.data.to)
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesExplorerOpen',
    group = Config.gr,
    callback = function()
      MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
      MiniFiles.set_bookmark(
        'p',
        vim.fn.stdpath('data') .. '/site/pack/core/opt',
        { desc = 'Plugins' }
      )
      MiniFiles.set_bookmark(
        '_',
        vim.fn.getcwd(),
        { desc = 'Working directory' }
      )
      MiniFiles.set_bookmark(
        'd',
        vim.env.HOME .. '/Developer',
        { desc = 'Projects' }
      )
      MiniFiles.set_bookmark('h', vim.env.HOME, { desc = 'Home directory' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesWindowUpdate',
    callback = function(e)
      local config = vim.api.nvim_win_get_config(e.data.win_id)
      config.height = vim.o.lines
      local n = #config.title
      config.title[1][1] = config.title[1][1]:gsub('^ ', '')
      config.title[n][1] = config.title[n][1]:gsub(' $', '')
      vim.api.nvim_win_set_config(e.data.win_id, config)
    end,
  })

  local function open_explorer_here()
    local file = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(file, false)
  end

  vim.keymap.set('n', '<Leader>ef', open_explorer_here, { desc = 'Explorer' })
end)

Config.later(function()
  require('mini.pick').setup({ window = { prompt_prefix = ' ' } })

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(items, opts, on_choice, {
      window = {
        config = {
          relative = 'cursor',
          anchor = 'NW',
          row = 0,
          col = 0,
          width = 80,
          height = 15,
        },
      },
    })
  end

  vim.keymap.set(
    'n',
    '<Leader>fb',
    '<Cmd>Pick buffers<CR>',
    { desc = 'Buffers' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fc',
    '<Cmd>Pick commands<CR>',
    { desc = 'Commands' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fd',
    '<Cmd>Pick diagnostic<CR>',
    { desc = 'Diagnostics' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fe',
    '<Cmd>Pick explorer<CR>',
    { desc = 'Explorer' }
  )

  vim.keymap.set(
    'n',
    '<Leader>ff',
    '<Cmd>Pick files<CR>',
    { desc = 'Find Files' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fg',
    '<Cmd>Pick grep_live<CR>',
    { desc = 'Grep live' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fh',
    "<Cmd>Pick help default_split='vertical'<CR>",
    { desc = 'Help files' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fH',
    '<Cmd>Pick hl_groups<CR>',
    { desc = 'Highlights' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fk',
    '<Cmd>Pick keymaps<CR>',
    { desc = 'Keymaps' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fl',
    "<Cmd>Pick buf_lines scope='current' preserve_order=true<CR>",
    { desc = 'Lines' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fm',
    '<Cmd>Pick manpages<CR>',
    { desc = 'Search manpages' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fo',
    '<Cmd>Pick visit_paths preserve_order=true<CR>',
    { desc = 'Oldfiles' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fq',
    "<Cmd>Pick list scope='quickfix'<CR>",
    { desc = 'Quickfix' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fr',
    '<Cmd>Pick resume<CR>',
    { desc = 'Resume last picker' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fu',
    '<Cmd>Pick git_hunks<CR>',
    { desc = 'Git hunks' }
  )

  vim.keymap.set(
    'n',
    '<Leader>fU',
    '<Cmd>Pick git_hunks scope="staged"<CR>',
    { desc = 'Git hunks' }
  )

  vim.keymap.set(
    'n',
    '<Leader>lD',
    "<Cmd>Pick lsp scope='declaration'<CR>",
    { desc = 'Declarations' }
  )

  vim.keymap.set(
    'n',
    '<Leader>lS',
    "<Cmd>Pick lsp scope='workspace_symbol_live'<CR>",
    { desc = 'Workspace symbols' }
  )

  vim.keymap.set(
    'n',
    '<Leader>ld',
    "<Cmd>Pick lsp scope='definition'<CR>",
    { desc = 'Definitions' }
  )

  vim.keymap.set(
    'n',
    '<Leader>li',
    "<Cmd>Pick lsp scope='implementation'<CR>",
    { desc = 'Implementations' }
  )

  vim.keymap.set(
    'n',
    '<Leader>lr',
    "<Cmd>Pick lsp scope='references'<CR>",
    { desc = 'References' }
  )

  vim.keymap.set(
    'n',
    '<Leader>ls',
    "<Cmd>Pick lsp scope='document_symbol'<CR>",
    { desc = 'Document Symbols' }
  )

  vim.keymap.set(
    'n',
    '<Leader>lt',
    "<Cmd>Pick lsp scope='type_definition'<CR>",
    { desc = 'Typedefs' }
  )
end)

Config.later(function()
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
    window = {
      delay = 500,
      scroll_down = '<C-f>',
      scroll_up = '<C-b>',
      config = { width = 'auto' },
    },
  })
end)

Config.later(function()
  require('mini.align').setup()
end)
Config.later(function()
  require('mini.operators').setup()
end)
Config.later(function()
  require('mini.move').setup()
end)
Config.later(function()
  require('mini.surround').setup()
end)
Config.later(function()
  require('mini.splitjoin').setup()
end)
Config.later(function()
  require('mini.cmdline').setup()
end)
Config.later(function()
  require('mini.bracketed').setup()
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/b0o/SchemaStore.nvim' })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/tpope/vim-sleuth' })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/tpope/vim-fugitive' })
  vim.keymap.set('n', '<Leader>gf', '<Cmd>Git<CR>', { desc = 'Open fugitive' })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })
  require('lualine').setup()
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/windwp/nvim-ts-autotag' })
  require('nvim-ts-autotag').setup()
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })
  require('ts-comments').setup({ lang = { typst = { '// %s', '/* %s */' } } })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/MagicDuck/grug-far.nvim' })

  require('grug-far').setup({
    folding = { enabled = false },
    resultLocation = { showNumberLabel = false },
  })

  local function grug_search_replace()
    require('grug-far').open({ transient = true })
  end

  vim.keymap.set(
    { 'n', 'x' },
    '<Leader>ug',
    grug_search_replace,
    { desc = 'Search & Replace' }
  )
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

  local function term_nav(dir)
    return function(self)
      return self:is_floating() and '<c-' .. dir .. '>'
        or vim.schedule(function()
          vim.cmd.wincmd(dir)
        end)
    end
  end

  local function term_close()
    vim.schedule(function()
      vim.cmd.wincmd('c')
    end)
  end

  local function term_normal(self)
    self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
    if self.esc_timer:is_active() then
      self.esc_timer:stop()
      vim.cmd('stopinsert')
    else
      self.esc_timer:start(200, 0, function() end)
      return '<esc>'
    end
  end

  local function visit_file_under_cursor(self)
    local f = vim.fn.findfile(vim.fn.expand('<cfile>'), '**')
    if f == '' then
      Snacks.notify.warn('No file under cursor')
    else
      self:hide()
      vim.schedule(function()
        vim.cmd('e ' .. f)
      end)
    end
  end

  require('snacks').setup({
    bigfile = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    terminal = {
      win = {
        -- stylua: ignore
        keys = {
          q = 'hide',
          nav_h       = { '<C-h>', term_nav('h'), desc = 'Go to Left Window',            expr = true, mode = 't' },
          nav_j       = { '<C-j>', term_nav('j'), desc = 'Go to Lower Window',           expr = true, mode = 't' },
          nav_k       = { '<C-k>', term_nav('k'), desc = 'Go to Upper Window',           expr = true, mode = 't' },
          nav_l       = { '<C-l>', term_nav('l'), desc = 'Go to Right Window',           expr = true, mode = 't' },
          term_close  = { '<C-g>', term_close,    desc = 'Close Terminal',               expr = true, mode = 't' },
          term_normal = { '<esc>', term_normal,   desc = 'Double escape to normal mode', expr = true, mode = 't' },
          gf = visit_file_under_cursor,
        },
      },
    },
  })

  vim.keymap.set(
    'n',
    '<Leader>gg',
    '<Cmd>lua Snacks.lazygit()<CR>',
    { desc = 'LazyGit' }
  )

  vim.keymap.set(
    'n',
    '<Leader>tt',
    '<Cmd>lua Snacks.terminal()<CR>',
    { desc = 'Open Default Terminal' }
  )

  vim.keymap.set(
    'n',
    '<Leader>ac',
    '<Cmd>lua Snacks.terminal("cursor-agent")<CR>',
    { desc = 'Open Cursor' }
  )
end)

Config.later(function()
  vim.pack.add({ 'https://github.com/greggh/claude-code.nvim' })

  require('claude-code').setup({
    window = {
      split_ratio = 0.5,
      -- Position of the window: "botright", "topleft", "vertical", "float", etc.
      position = 'botright',
      float = {
        border = vim.o.winborder,
      },
    },
    keymaps = {
      toggle = {
        normal = '<M-c>',
        terminal = '<M-c>',
      },
    },
  })

  vim.keymap.set(
    'n',
    '<Leader>cc',
    '<cmd>ClaudeCode<CR>',
    { desc = 'Toggle Claude Code' }
  )
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/3rd/image.nvim' })

  require('image').setup()
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/HakonHarnes/img-clip.nvim' })

  require('img-clip').setup({ default = { dir_path = 'static/img' } })
end)

Config.now_if_args(function()
  Config.on_packchanged(
    'markdown-preview.nvim',
    { 'install', 'update' },
    function(e)
      MiniMisc.log_add(
        'Building dependencies',
        { name = e.data.spec.name, path = e.data.path }
      )

      local stdout = vim
        .system({ 'npm', 'install' }, { text = true, cwd = e.data.path .. '/app' })
        :wait()

      if stdout.code ~= 0 then
        MiniMisc.log_add(
          'Error during dependencies build',
          { name = e.data.spec.name, path = e.data.path }
        )
      else
        MiniMisc.log_add(
          'Dependencies built',
          { name = e.data.spec.name, path = e.data.path }
        )
      end
    end
  )

  vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/chomosuke/typst-preview.nvim' })

  require('typst-preview').setup({
    dependencies_bin = {
      ['tinymist'] = 'tinymist',
      ['websocat'] = nil,
    },
  })

  vim.api.nvim_create_user_command('TypstOpenThisPdf', function()
    local filepath = vim.api.nvim_buf_get_name(0)

    if filepath:match('%.typ$') then
      local pdf_path = filepath:gsub('%.typ$', '.pdf')
      vim.system({ 'xdg-open', pdf_path })
    end
  end, {})
end)

Config.now_if_args(function()
  Config.on_packchanged('nvim-treesitter', { 'update' }, function(e)
    MiniMisc.log_add(
      'Updating parsers',
      { name = e.data.spec.name, path = e.data.path }
    )
    vim.cmd('TSUpdate')
    MiniMisc.log_add(
      'Parsers updates',
      { name = e.data.spec.name, path = e.data.path }
    )
  end)

  vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  -- stylua: ignore
  local treesit_langs = {
    -- NOTE: parsers for c, lua, vim, vimdoc, query and markdown are already included in neovim
    'bash',      'c',   'css',      'diff',   'dockerfile', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit',
    'gitignore', 'go',  'gomod',    'gosum',  'gowork',     'html',       'javascript', 'json',          'json5',
    'jsx',       'lua', 'markdown', 'python', 'regex',      'ruby',       'toml',       'tsx',           'typescript',
    'typst',     'vim', 'vimdoc',   'yaml',   'jsdoc'
  }

  require('nvim-treesitter').install(vim
    .iter(treesit_langs)
    :filter(function(item)
      return #vim.api.nvim_get_runtime_file('parser/' .. item .. '.*', false)
        == 0
    end)
    :flatten()
    :totable())

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('crnvl96-nvim-treesitter', {}),
    pattern = vim
      .iter(treesit_langs)
      :map(function(item)
        return vim.treesitter.language.get_filetypes(item)
      end)
      :flatten()
      :totable(),
    callback = function(ev)
      vim.treesitter.start(ev.buf)
    end,
  })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

  -- stylua: ignore
  vim.lsp.enable({
    'biome',  'eslint',  'gopls',    'lua_ls', 'oxfmt',
    'oxlint', 'rubocop', 'ruby_lsp', 'ruff',   'tinymist',
    'tsgo',   'ty',      'jsonls',   'yamlls'
    -- 'pyright', 'harper_ls'
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = Config.gr,
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then
        return
      end
      --
      -- Gopls extra config
      --
      if client.name == 'gopls' then
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        if not client.server_capabilities.semanticTokensProvider then
          local semantic =
            client.config.capabilities.textDocument.semanticTokens
          if not semantic then
            return
          end
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {
              tokenTypes = semantic.tokenTypes,
              tokenModifiers = semantic.tokenModifiers,
            },
            range = true,
          }
        end
      end
    end,
  })

  vim.keymap.set(
    'n',
    'E',
    '<Cmd>lua vim.diagnostic.open_float()<CR>',
    { desc = 'Open Current Diagnostic' }
  )

  vim.keymap.set(
    'n',
    'K',
    '<Cmd>lua vim.lsp.buf.hover()<CR>',
    { desc = 'Inspect Current Symbol' }
  )

  vim.keymap.set(
    'i',
    '<C-k>',
    '<Cmd>lua vim.lsp.buf.signature_help()<CR>',
    { desc = 'Show Signature Help' }
  )

  vim.keymap.set(
    'n',
    '<Leader>la',
    '<Cmd>lua vim.lsp.buf.code_action()<CR>',
    { desc = 'LSP Code actions' }
  )

  vim.keymap.set(
    'n',
    '<Leader>ln',
    '<Cmd>lua vim.lsp.buf.rename()<CR>',
    { desc = 'LSP Rename' }
  )
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

  local autoformat = true

  require('conform').setup({
    notify_on_error = false,
    notify_no_formatters = false,
    default_format_opts = {
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },
    formatters = {
      stylua = {
        require_cwd = true,
      },
      prettier = {
        require_cwd = false,
      },
    },
    format_on_save = function()
      if not autoformat then
        return nil
      end
      return {}
    end,
    formatters_by_ft = {
      javascript = {
        'prettier',
        lsp_format = 'prefer',
        timeout_ms = 1000,
      },
      typescript = {
        'prettier',
        lsp_format = 'prefer',
        timeout_ms = 1000,
      },
      javascriptreact = {
        'prettier',
        lsp_format = 'prefer',
        timeout_ms = 1000,
      },
      typescriptreact = {
        'prettier',
        lsp_format = 'prefer',
        timeout_ms = 1000,
      },
      typst = { 'typstyle', lsp_format = 'prefer' },
      go = { lsp_format = 'prefer' },
      ['_'] = { 'trim_whitespace', 'trim_newline' },
      python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
      lua = { 'stylua' },
      json = { 'prettier' },
      css = { 'prettier' },
      jsonc = { 'prettier' },
      json5 = { 'prettier' },
      ruby = { 'rubocop' },
      yaml = { 'prettier' },
      markdown = { 'prettier', 'injected' },
    },
  })

  local toggle_autoformat = function()
    autoformat = not autoformat
  end

  vim.keymap.set(
    'n',
    '<Leader>uf',
    toggle_autoformat,
    { desc = 'Toggle autoformat' }
  )

  vim.keymap.set(
    'n',
    '<Leader>ur',
    '<Cmd>lua MiniMisc.put(MiniMisc.find_root())<CR>',
    { desc = 'Find current root' }
  )
end)
