local add = MiniDeps.add

add({ source = 'phha/zenburn.nvim' })

require('zenburn').setup()

vim.cmd('colorscheme zenburn')
