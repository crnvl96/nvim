MiniDeps.add({ source = 'williamboman/mason.nvim', hooks = { post_checkout = function() vim.cmd('MasonUpdate') end } })

local mason = require('mason')

mason.setup()

local ensure_installed = {}

vim.list_extend(ensure_installed, vim.tbl_keys(require('tools').servers))
vim.list_extend(ensure_installed, require('tools').formatters)
vim.list_extend(ensure_installed, require('tools').debuggers)

MiniDeps.add({ source = 'WhoIsSethDaniel/mason-tool-installer.nvim' })

local mts = require('mason-tool-installer')

mts.setup({ ensure_installed = ensure_installed })
