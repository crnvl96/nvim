local misc = require('mini.misc')

misc.setup_restore_cursor({ center = true })
misc.setup_auto_root()
misc.setup_termbg_sync()

vim.keymap.set('n', '<c-w>z', misc.zoom, { desc = 'zoom' })
