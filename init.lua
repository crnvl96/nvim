local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/echasnovski/mini.nvim',
        mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

local deps = require('mini.deps')
deps.setup({ path = { package = path_package } })

local add, now, ltr = deps.add, deps.now, deps.later

local function rc(modname)
    return function() require('config.' .. modname) end
end

local function rp(modname)
    return function() require('plugins.' .. modname) end
end

now(rc('opts'))
now(rc('autocmds'))
now(rc('keymaps'))

now(function()
    add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_update = function() vim.cmd('TSUpdate') end } })
    add({ source = 'williamboman/mason.nvim', hooks = { post_checkout = function() vim.cmd('MasonUpdate') end } })
    add({ source = 'junegunn/fzf', hooks = { post_checkout = function() vim.fn['fzf#install']() end } })
    add({ source = 'EdenEast/nightfox.nvim' })
    add({ source = 'nvim-lua/plenary.nvim' })
    add({ source = 'nvim-neotest/nvim-nio' })
    add({ source = 'williamboman/mason-lspconfig.nvim' })
    add({ source = 'WhoIsSethDaniel/mason-tool-installer.nvim' })
    add({ source = 'theHamsta/nvim-dap-virtual-text' })
    add({ source = 'rcarriga/nvim-dap-ui' })
    add({ source = 'leoluz/nvim-dap-go' })
    add({ source = 'mfussenegger/nvim-dap' })
    add({ source = 'jay-babu/mason-nvim-dap.nvim' })
    add({ source = 'MagicDuck/grug-far.nvim' })
    add({ source = 'stevearc/oil.nvim' })
    add({ source = 'ibhagwan/fzf-lua' })
    add({ source = 'tpope/vim-fugitive' })
    add({ source = 'tpope/vim-rhubarb' })
    add({ source = 'lewis6991/gitsigns.nvim' })
    add({ source = 'hrsh7th/cmp-buffer' })
    add({ source = 'hrsh7th/cmp-path' })
    add({ source = 'hrsh7th/cmp-nvim-lua' })
    add({ source = 'hrsh7th/cmp-nvim-lsp' })
    add({ source = 'hrsh7th/nvim-cmp' })
    add({ source = 'neovim/nvim-lspconfig' })
    add({ source = 'stevearc/conform.nvim' })
    add({ source = 'stevearc/quicker.nvim' })
    add({ source = 'kevinhwang91/nvim-bqf' })
    add({ source = 'nvim-treesitter/nvim-treesitter-textobjects' })
    add({ source = 'OXY2DEV/markview.nvim' })
end)

now(rp('bootstrap'))
now(rp('treesitter'))
now(rp('fileexplorer'))
now(rp('lang'))
now(rp('lsp'))
now(rp('dap'))
ltr(rp('git'))
ltr(rp('quickfix'))
ltr(rp('clue'))
