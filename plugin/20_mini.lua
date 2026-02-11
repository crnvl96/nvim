MiniDeps.now(function()
  require('mini.icons').setup()
  MiniDeps.later(MiniIcons.mock_nvim_web_devicons)
  MiniDeps.later(MiniIcons.tweak_lsp_kind)
end)

MiniDeps.now(function()
  require('mini.notify').setup({
    content = {
      format = function(notif)
        if notif.data.source == 'lsp_progress' then return notif.msg end
        return MiniNotify.default_format(notif)
      end,
      sort = function(notif_arr)
        table.sort(notif_arr, function(a, b) return a.ts_update > b.ts_update end)
        return notif_arr
      end,
    },
  })
end)

MiniDeps.now(function()
  require('mini.misc').setup()
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)

MiniDeps.later(function() require('mini.extra').setup() end)
MiniDeps.later(function() require('mini.align').setup() end)
MiniDeps.later(function() require('mini.move').setup() end)
MiniDeps.later(function() require('mini.splitjoin').setup() end)
MiniDeps.later(function() require('mini.trailspace').setup() end)
MiniDeps.later(function() require('mini.indentscope').setup() end)
MiniDeps.later(function() require('mini.comment').setup() end)
MiniDeps.later(function() require('mini.operators').setup() end)

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
