Config.later(function() require('mini.extra').setup() end)
Config.later(function() require('mini.visits').setup() end)
Config.later(function() require('mini.align').setup() end)
Config.later(function() require('mini.operators').setup() end)
Config.later(function() require('mini.move').setup() end)
Config.later(function() require('mini.surround').setup() end)
Config.later(function() require('mini.splitjoin').setup() end)
Config.later(function() require('mini.cmdline').setup() end)
Config.later(function() require('mini.bracketed').setup() end)

Config.later(function()
  require('mini.colors').setup()
  MiniColors.get_colorscheme():add_transparency({ general = false, float = true }):apply()
end)

Config.now(function()
  require('mini.icons').setup({
    -- rely on `vim.filetype.match` for these extensions
    use_file_extension = function(ext, _)
      local last_three_letters, last_four_letters = ext:sub(-3), ext:sub(-4)
      return last_three_letters ~= 'scm'
        and last_three_letters ~= 'txt'
        and last_three_letters ~= 'yml'
        and last_four_letters ~= 'json'
        and last_four_letters ~= 'yaml'
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
  require('mini.indentscope').setup({
    options = {
      border = 'both',
      try_as_border = true,
    },
    symbol = '│',
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = Config.gr,
    pattern = { 'snacks_terminal', 'terminal', 'term' },
    callback = function(e) vim.b[e.buf].miniindentscope_disable = true end,
  })
end)

Config.later(function()
  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        local default = MiniCompletion.default_process_items
        return default(items, base, { kind_priority = { Text = -1, Snippet = -1 } })
      end,
    },
  })

  vim.lsp.config('*', {
    capabilities = MiniCompletion.get_lsp_capabilities(),
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = Config.gr,
    callback = function(e) vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
  })
end)

Config.later(
  function()
    require('mini.hipatterns').setup({
      highlighters = {
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      },
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

Config.later(
  function()
    require('mini.pairs').setup({
      modes = {
        insert = true,
        command = true,
        terminal = false,
      },
    })
  end
)

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
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
  MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })
  MiniKeymap.map_multistep(
    'i',
    '<Tab>',
    { 'minisnippets_next', 'minisnippets_expand', 'pmenu_next', 'jump_after_tsnode', 'jump_after_close' }
  )
  MiniKeymap.map_multistep(
    'i',
    '<S-Tab>',
    { 'minisnippets_prev', 'pmenu_prev', 'jump_before_tsnode', 'jump_before_open' }
  )
end)

Config.later(function()
  local snippets, config_path = require('mini.snippets'), vim.fn.stdpath('config')

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

  local filter_show = function() return true end
  local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, '.') end

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
    callback = function(e) Snacks.rename.on_rename_file(e.data.from, e.data.to) end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesExplorerOpen',
    group = Config.gr,
    callback = function()
      MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
      MiniFiles.set_bookmark('p', vim.fn.stdpath('data') .. '/site/pack/core/opt', { desc = 'Plugins' })
      MiniFiles.set_bookmark('_', vim.fn.getcwd, { desc = 'Working directory' })
      MiniFiles.set_bookmark('n', vim.env.HOME .. '/Developer/personal/notes', { desc = 'Notes' })
      MiniFiles.set_bookmark('d', vim.env.HOME .. '/Developer', { desc = 'Projects' })
      MiniFiles.set_bookmark('h', vim.env.HOME, { desc = 'Home' })
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

  Config.set_keymap('n', '<Leader>ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>', 'Explorer')
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

  Config.set_keymap('n', '<Leader>fb', '<Cmd>Pick buffers<CR>', 'Buffers')
  Config.set_keymap('n', '<Leader>fc', '<Cmd>Pick commands<CR>', 'Commands')
  Config.set_keymap('n', '<Leader>fd', '<Cmd>Pick diagnostic<CR>', 'Diagnostics')
  Config.set_keymap('n', '<Leader>fe', '<Cmd>Pick explorer<CR>', 'Explorer')
  Config.set_keymap('n', '<Leader>ff', '<Cmd>Pick files<CR>', 'Files')
  Config.set_keymap('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
  Config.set_keymap('n', '<Leader>fh', "<Cmd>Pick help default_split='vertical'<CR>", 'Help files')
  Config.set_keymap('n', '<Leader>fH', '<Cmd>Pick hl_groups<CR>', 'Highlights')
  Config.set_keymap('n', '<Leader>fk', '<Cmd>Pick keymaps<CR>', 'Keymaps')
  Config.set_keymap('n', '<Leader>fl', "<Cmd>Pick buf_lines scope='current' preserve_order=true<CR>", 'Lines')
  Config.set_keymap('n', '<Leader>fm', '<Cmd>Pick manpages<CR>', 'Search manpages')
  Config.set_keymap('n', '<Leader>fo', '<Cmd>Pick visit_paths preserve_order=true<CR>', 'Oldfiles')
  Config.set_keymap('n', '<Leader>fq', "<Cmd>Pick list scope='quickfix'<CR>", 'Quickfix')
  Config.set_keymap('n', '<Leader>fr', '<Cmd>Pick resume<CR>', 'Resume')
  Config.set_keymap('n', '<Leader>fu', '<Cmd>Pick git_hunks<CR>', 'Git hunks')

  Config.set_keymap('n', '<Leader>lD', "<Cmd>Pick lsp scope='declaration'<CR>", 'Declarations')
  Config.set_keymap('n', '<Leader>lS', "<Cmd>Pick lsp scope='workspace_symbol_live'<CR>", 'Workspace symbols')
  Config.set_keymap('n', '<Leader>ld', "<Cmd>Pick lsp scope='definition'<CR>", 'Definitions')
  Config.set_keymap('n', '<Leader>li', "<Cmd>Pick lsp scope='implementation'<CR>", 'Implementations')
  Config.set_keymap('n', '<Leader>lr', "<Cmd>Pick lsp scope='references'<CR>", 'References')
  Config.set_keymap('n', '<Leader>ls', "<Cmd>Pick lsp scope='document_symbol'<CR>", 'Document Symbols')
  Config.set_keymap('n', '<Leader>lt', "<Cmd>Pick lsp scope='type_definition'<CR>", 'Typedefs')
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
      window = {
        delay = 500,
        scroll_down = '<C-f>',
        scroll_up = '<C-b>',
        config = { width = 'auto' },
      },
    })
  end
)
