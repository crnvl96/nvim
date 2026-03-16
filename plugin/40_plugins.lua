Config.now(function()
  vim.pack.add({ 'https://github.com/rebelot/kanagawa.nvim' })
  vim.cmd('colorscheme kanagawa')
end)

Config.now_if_args(
  function() vim.pack.add({ 'https://github.com/b0o/SchemaStore.nvim' }) end
)

Config.now_if_args(
  function() vim.pack.add({ 'https://github.com/tpope/vim-sleuth' }) end
)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/windwp/nvim-ts-autotag' })
  require('nvim-ts-autotag').setup()
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })
  require('ts-comments').setup({
    lang = {
      typst = { '// %s', '/* %s */' },
    },
  })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/3rd/image.nvim' })
  require('image').setup()
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/HakonHarnes/img-clip.nvim' })
  require('img-clip').setup({
    default = {
      dir_path = 'static/img',
    },
  })
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

  vim.api.nvim_create_user_command('TypstPreviewOpenThisPdf', function()
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath:match('%.typ$') then
      local pdf_path = filepath:gsub('%.typ$', '.pdf')
      vim.system({ 'xdg-open', pdf_path })
    end
  end, {})
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
      stylua = { require_cwd = true },
      prettier = { require_cwd = false },
      oxfmt = { require_cwd = false },
    },
    formatters_by_ft = Config.formatters_by_ft,
    format_on_save = function()
      if not autoformat then return nil end
      return {}
    end,
  })

  local toggle_autoformat = function() autoformat = not autoformat end

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

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })
  vim.lsp.enable(Config.servers)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = Config.gr,
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end
      if client.name == 'gopls' then
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        if not client.server_capabilities.semanticTokensProvider then
          local semantic =
            client.config.capabilities.textDocument.semanticTokens
          if not semantic then return end
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

  local function exists(parser)
    local result =
      vim.api.nvim_get_runtime_file('parser/' .. parser .. '.*', false)
    return #result == 0
  end

  require('nvim-treesitter').install(
    vim.iter(Config.parsers):filter(exists):flatten():totable()
  )

  local function lang_fts(lang)
    local fts = vim.treesitter.language.get_filetypes(lang)
    return fts
  end

  local pattern = vim.iter(Config.parsers):map(lang_fts):flatten():totable()

  vim.api.nvim_create_autocmd('FileType', {
    group = Config.gr,
    pattern = pattern,
    callback = function(ev) vim.treesitter.start(ev.buf) end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = Config.gr,
    callback = function()
      vim.cmd('setlocal formatoptions-=c formatoptions-=o')
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
    end,
  })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/esmuellert/codediff.nvim' })

  require('codediff').setup({
    diff = {
      layout = 'inline',
      compute_moves = true,
      jump_to_first_change = false,
    },
    explorer = { width = 30 },
  })

  vim.keymap.set(
    'n',
    '<Leader>gd',
    '<Cmd>CodeDiff<CR>',
    { desc = 'Toggle git diff' }
  )
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/MagicDuck/grug-far.nvim' })

  require('grug-far').setup({
    folding = { enabled = false },
    resultLocation = { showNumberLabel = false },
  })

  local function gf()
    local grug = require('grug-far')
    grug.open({ transient = true })
  end

  vim.keymap.set('n', '<Leader>us', gf, { desc = 'Grugfar' })
end)

Config.now_if_args(
  function()
    require('mini.ai').setup({
      search_method = 'cover',
      custom_textobjects = {
        g = MiniExtra.gen_ai_spec.buffer(),
        f = require('mini.ai').gen_spec.treesitter({
          a = '@function.outer',
          i = '@function.inner',
        }),
        t = {
          '<([%p%w]-)%f[^<%w][^<>]->.-</%1>',
          '^<.->().*()</[^/]->$',
        },
      },
    })
  end
)

Config.now_if_args(function() require('mini.align').setup() end)

Config.now_if_args(function()
  require('mini.bufremove').setup()

  local function wipeout_all_buffers()
    local current_buffer = vim.api.nvim_get_current_buf()
    vim
      .iter(vim.api.nvim_list_bufs())
      :filter(function(bufnr) return bufnr ~= current_buffer end)
      :each(function(bufnr) MiniBufremove.wipeout(bufnr, true) end)
  end

  vim.keymap.set(
    'n',
    '<Leader>uo',
    wipeout_all_buffers,
    { desc = 'Wipeout Other Buffers' }
  )

  vim.keymap.set(
    'n',
    '<Leader>uO',
    '<Cmd>tabonly<CR>',
    { desc = 'Close other tabs' }
  )
end)

Config.now_if_args(
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

Config.now_if_args(function() require('mini.cmdline').setup() end)

Config.now_if_args(function()
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

  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = Config.gr,
    callback = function(e)
      vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end,
  })
end)

Config.now_if_args(function()
  require('mini.files').setup({
    content = { prefix = function() end },
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
    group = Config.gr,
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
    pattern = 'MiniFilesExplorerOpen',
    group = Config.gr,
    callback = function()
      MiniFiles.set_bookmark(
        '_',
        vim.fn.getcwd(),
        { desc = 'Working directory' }
      )
      MiniFiles.set_bookmark(
        '@',
        vim.env.HOME .. '/Developer',
        { desc = 'Projects' }
      )
      MiniFiles.set_bookmark('.', vim.env.HOME, { desc = 'Home directory' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesWindowUpdate',
    group = Config.gr,
    callback = function(e)
      local config = vim.api.nvim_win_get_config(e.data.win_id)
      config.height = vim.o.lines
      vim.api.nvim_win_set_config(e.data.win_id, config)
    end,
  })

  local function open_explorer_here()
    local file = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(file, false)
  end

  vim.keymap.set('n', '<Leader>ef', open_explorer_here, { desc = 'Explorer' })
end)

Config.now_if_args(
  function()
    require('mini.hipatterns').setup({
      highlighters = {
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      },
    })
  end
)

Config.now_if_args(function()
  require('mini.indentscope').setup({
    options = {
      try_as_border = true,
    },
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = Config.gr,
    pattern = { 'terminal' },
    callback = function(e) vim.b[e.buf].miniindentscope_disable = true end,
  })
end)

Config.now_if_args(
  function()
    require('mini.jump2d').setup({
      spotter = require('mini.jump2d').gen_spotter.pattern('[^%s%p]+'),
      labels = 'asdfghjklweruioxcvn,.',
      view = {
        dim = true,
        n_steps_ahead = 2,
      },
    })
  end
)

Config.now_if_args(function()
  require('mini.keymap').setup()

  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
  MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })
  MiniKeymap.map_multistep(
    'i',
    '<Tab>',
    { 'minisnippets_next', 'minisnippets_expand', 'pmenu_next' }
  )
  MiniKeymap.map_multistep(
    'i',
    '<S-Tab>',
    { 'minisnippets_prev', 'pmenu_prev' }
  )
end)

Config.now_if_args(function() require('mini.move').setup() end)

Config.now_if_args(function() require('mini.operators').setup() end)

Config.now_if_args(
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

Config.now_if_args(function()
  require('mini.pick').setup({
    source = {
      show = require('mini.pick').default_show,
    },
    window = {
      prompt_prefix = ' ',
    },
  })

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

Config.now_if_args(function()
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

Config.now_if_args(function() require('mini.splitjoin').setup() end)

Config.now_if_args(function() require('mini.surround').setup() end)

Config.now_if_args(function() require('mini.statusline').setup() end)

Config.now_if_args(
  function()
    require('mini.bracketed').setup({
      indent = { suffix = '', options = {} },
    })
  end
)

Config.now_if_args(function()
  require('mini.git').setup()

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniGitCommandSplit',
    group = Config.gr,
    callback = function(e)
      if e.data.git_subcommand ~= 'status' then return end
      vim.api.nvim_set_option_value(
        'filetype',
        'gitstatus',
        { scope = 'local', buf = vim.api.nvim_win_get_buf(e.data.win_stdout) }
      )
    end,
  })

  vim.keymap.set(
    'n',
    '<Leader>gs',
    '<Cmd>Git status<CR>',
    { desc = 'Git status' }
  )

  vim.keymap.set(
    'n',
    '<Leader>gc',
    '<Cmd>Git commit<CR>',
    { desc = 'Git commit' }
  )
end)

Config.now_if_args(function()
  require('mini.diff').setup({
    view = { style = 'sign' },
  })

  vim.keymap.set(
    'n',
    '<Leader>go',
    function() MiniDiff.toggle_overlay() end,
    { desc = 'Toggle git overlay' }
  )

  vim.keymap.set('n', '<Leader>ge', function()
    vim.fn.setqflist(MiniDiff.export('qf'))
    vim.cmd('copen')
  end, { desc = 'Export to Quickfix' })
end)
