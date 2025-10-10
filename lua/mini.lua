require('mini.extra').setup {}
require('mini.misc').setup {}
require('mini.align').setup {}
require('mini.splitjoin').setup {}

MiniMisc.setup_restore_cursor()
MiniMisc.setup_auto_root()

vim.keymap.set('n', 'L', MiniMisc.zoom)
