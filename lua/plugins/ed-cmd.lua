MiniDeps.add('smilhey/ed-cmd.nvim')

require('ed-cmd').setup({
    cmdline = { keymaps = { edit = '<ESC>', execute = '<CR>', close = '<C-c>' } },
    pumenu = { max_items = 100 },
})
