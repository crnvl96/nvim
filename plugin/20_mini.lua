local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ name = 'mini.nvim' })

now(function() vim.cmd('colorscheme minigrey') end)
now(function() require('mini.misc').setup_auto_root() end)
now(function() require('mini.misc').setup_termbg_sync() end)

later(function() require('mini.extra').setup() end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.doc').setup() end)
later(function() require('mini.git').setup() end)
later(function() require('mini.operators').setup() end)
later(function() require('mini.visits').setup() end)

now(function()
  require('mini.notify').setup(Plugin.mininotify_opts())
  vim.notify = MiniNotify.make_notify()
end)

now(function() Config.check_cli_requirements() end)

now(function()
  require('mini.icons').setup(Plugin.miniicons_opts())
  MiniIcons.mock_nvim_web_devicons()
  later(MiniIcons.tweak_lsp_kind)
end)

later(function() require('mini.clue').setup(Plugin.miniclue_opts()) end)
later(function() require('mini.files').setup(Plugin.minifiles_opts()) end)

later(function()
  require('mini.pick').setup(Plugin.minipick_opts())
  vim.ui.select = MiniPick.ui_select
  Config.minipick_set_hls()
  Config.multigrep()
end)
