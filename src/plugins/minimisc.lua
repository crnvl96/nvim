require('mini.misc').setup({
  make_global = {
    'put',
    'put_text',
    'stat_summary',
    'bench_time',
  },
})

MiniMisc.setup_auto_root()
MiniMisc.setup_termbg_sync()
MiniMisc.setup_restore_cursor()
