vim.o.guicursor = ''
vim.o.splitkeep = 'screen'
vim.o.number = true
vim.o.relativenumber = true
vim.o.timeoutlen = 200
vim.o.swapfile = false
vim.o.scrolloff = 8

if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end
vim.cmd('packadd cfilter')

require('mini.basics').setup({
    options = {
        basic = true,
        extra_ui = true,
        win_borders = 'double',
    },
    mappings = {
        basic = true,
        option_toggle_prefix = [[\]],
        windows = false,
        move_with_alt = false,
    },
    autocommands = {
        basic = true,
        relnum_in_visual_mode = false,
    },
})

vim.o.pumblend = 0
vim.o.winblend = 0
vim.o.list = false
