MiniDeps.now(function() require('mini.notify').setup() end)
MiniDeps.now(function() require('mini.hues').setup({ background = '#002734', foreground = '#c0c8cc' }) end)

MiniDeps.now(function()
  require('mini.icons').setup()
  MiniDeps.later(MiniIcons.mock_nvim_web_devicons)
  MiniDeps.later(MiniIcons.tweak_lsp_kind)
end)

MiniDeps.now(function()
  require('mini.misc').setup()
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)

MiniDeps.later(function() require('mini.extra').setup() end)
MiniDeps.later(function() require('mini.visits').setup() end)
MiniDeps.later(function() require('mini.align').setup() end)
MiniDeps.later(function() require('mini.move').setup() end)
MiniDeps.later(function() require('mini.splitjoin').setup() end)
MiniDeps.later(function() require('mini.trailspace').setup() end)
MiniDeps.later(function() require('mini.indentscope').setup() end)
MiniDeps.later(function() require('mini.comment').setup() end)
MiniDeps.later(function() require('mini.operators').setup() end)
-- MiniDeps.later(function() require('mini.diff').setup() end)
-- MiniDeps.later(function() require('mini.git').setup() end)
-- MiniDeps.later(function() require('mini.statusline').setup() end)

MiniDeps.later(function()
  require('mini.colors').setup()
  MiniColors.get_colorscheme()
    :add_transparency({
      general = true,
      float = true,
      statuscolumn = true,
      statusline = true,
      tabline = true,
      winbar = true,
    })
    :apply()
end)

MiniDeps.later(function()
  local jump2d = require('mini.jump2d')
  jump2d.setup({
    spotter = jump2d.gen_spotter.pattern('[^%s%p]+'),
    labels = 'asdfghjkl;',
    view = {
      dim = true,
      n_steps_ahead = 2,
    },
  })
  vim.keymap.set({ 'n', 'x', 'o' }, 's', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)
end)

MiniDeps.later(function()
  require('mini.keymap').setup()
  require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
  require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')
  require('mini.keymap').map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
  require('mini.keymap').map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
  require('mini.keymap').map_combo({ 'n', 'i', 'x', 'c' }, '<Esc><Esc>', function() vim.cmd('nohlsearch') end)
end)

MiniDeps.later(function()
  local ai = require('mini.ai')
  ai.setup({
    custom_textobjects = {
      g = MiniExtra.gen_ai_spec.buffer(),
      f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      c = ai.gen_spec.treesitter({ a = '@comment.outer', i = '@comment.inner' }),
      o = ai.gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
      l = ai.gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' }),
    },
    search_method = 'cover',
  })
end)

MiniDeps.later(function()
  require('mini.files').setup({
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
    },
    windows = {
      max_number = 3,
      preview = true,
      width_focus = 50,
      width_nofocus = 20,
      width_preview = 80,
    },
  })
  vim.keymap.set('n', '<Leader>ef', function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end)
end)

MiniDeps.later(function()
  require('mini.pick').setup({
    window = {
      prompt_prefix = '  ',
    },
  })

  local cursor_based_display_opts = {
    window = {
      config = {
        relative = 'cursor',
        anchor = 'NW',
        row = 0,
        col = 0,
        width = 80,
        height = 20,
      },
    },
  }

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(items, opts, on_choice, cursor_based_display_opts)
  end

  vim.keymap.set('n', '<Leader>ff', function() MiniPick.builtin.files() end)
  vim.keymap.set('n', '<Leader>fg', function() MiniPick.builtin.grep_live() end)
  vim.keymap.set('n', '<Leader>fr', function() MiniPick.builtin.resume() end)
  vim.keymap.set(
    'n',
    '<Leader>fl',
    function()
      MiniExtra.pickers.buf_lines({
        scope = 'current',
        preserve_order = true,
      })
    end
  )
  vim.keymap.set('n', '<Leader>fq', function() MiniExtra.pickers.list({ scope = 'quickfix' }) end)
  vim.keymap.set('n', '<Leader>fk', function() MiniExtra.pickers.keymaps() end)
  vim.keymap.set('n', '<Leader>fH', function() MiniExtra.pickers.hl_groups() end)
  vim.keymap.set('n', '<Leader>fd', function() MiniExtra.pickers.diagnostic() end)
  vim.keymap.set('n', '<Leader>fc', function() MiniExtra.pickers.commands() end)
  vim.keymap.set(
    'n',
    '<Leader>fh',
    function()
      MiniPick.builtin.help({
        default_split = 'vertical',
      })
    end
  )
  vim.keymap.set(
    'n',
    '<Leader>fb',
    function() MiniPick.builtin.buffers({ include_current = false }, cursor_based_display_opts) end
  )
  vim.keymap.set('n', '<Leader>fm', function() MiniExtra.pickers.manpages() end)
  vim.keymap.set(
    'n',
    '<Leader>fo',
    function() MiniExtra.pickers.visit_paths({ preserve_order = true }, cursor_based_display_opts) end
  )

  vim.keymap.set('n', 'gD', function() MiniExtra.pickers.lsp({ scope = 'declaration' }) end)
  vim.keymap.set('n', 'gd', function() MiniExtra.pickers.lsp({ scope = 'definition' }) end)
  vim.keymap.set('n', 'gO', function() MiniExtra.pickers.lsp({ scope = 'document_symbol' }) end)
  vim.keymap.set('n', 'gS', function() MiniExtra.pickers.lsp({ scope = 'workspace_symbol_live' }) end)
  vim.keymap.set('n', 'gri', function() MiniExtra.pickers.lsp({ scope = 'implementation' }) end)
  vim.keymap.set('n', 'grr', function() MiniExtra.pickers.lsp({ scope = 'references' }) end)
  vim.keymap.set('n', 'gra', function() vim.lsp.buf.code_action() end)
  vim.keymap.set('n', 'grt', function() MiniExtra.pickers.lsp({ scope = 'type_definition' }) end)
end)
