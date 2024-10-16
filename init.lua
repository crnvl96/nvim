pcall(function() vim.loader.enable() end)

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

require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local path_source = vim.fn.stdpath('config') .. '/src/'
local source = function(path) dofile(path_source .. path) end

now(function() source('settings.lua') end)

later(function() add('tpope/vim-fugitive') end)

later(function() source('mini.lua') end)

later(function()
    add('stevearc/oil.nvim')
    source('oil.lua')
end)

now(function()
    add('sainnhe/edge')

    vim.g.edge_style = 'aura'
    vim.g.edge_dim_foreground = 1
    vim.g.edge_disable_italic_comment = 1
    vim.g.edge_better_performance = 1

    vim.cmd('colorscheme edge')
end)

now(function()
    add({ source = 'williamboman/mason.nvim', hooks = { post_checkout = function() vim.cmd('MasonUpdate') end } })
end)

now(function()
    add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_checkout = function() vim.cmd('TSUpdate') end } })
    source('treesitter.lua')
end)

now(function()
    add({
        source = 'neovim/nvim-lspconfig',
        depends = {
            {
                source = 'iguanacucumber/magazine.nvim',
                name = 'nvim-cmp',
                depends = {
                    { source = 'hrsh7th/cmp-buffer' },
                    { source = 'hrsh7th/cmp-nvim-lsp' },
                    { source = 'hrsh7th/cmp-nvim-lua' },
                    { source = 'hrsh7th/cmp-path' },
                    { source = 'hrsh7th/cmp-cmdline' },
                },
            },
            {
                source = 'williamboman/mason-lspconfig.nvim',
                depends = {
                    { source = 'williamboman/mason.nvim' },
                },
            },
        },
    })

    source('lsp.lua')
    source('completion.lua')
end)

later(function()
    add({
        source = 'stevearc/conform.nvim',
        depends = {
            { source = 'williamboman/mason.nvim' },
        },
    })

    source('conform.lua')
end)

later(function()
    add('folke/which-key.nvim')
    source('whichkey.lua')
end)

later(function()
    local build = function(args)
        local obj = vim.system({ 'make', '-C', args.path }, { text = true }):wait()
        vim.print(vim.inspect(obj))
    end

    add({
        source = 'nvim-telescope/telescope.nvim',
        depends = {
            { source = 'nvim-lua/plenary.nvim' },
            { source = 'nvim-telescope/telescope-ui-select.nvim' },
            { source = 'mfussenegger/nvim-dap' },
            { source = 'nvim-telescope/telescope-dap.nvim' },
            { source = 'nvim-treesitter/nvim-treesitter' },
            {
                source = 'nvim-telescope/telescope-fzf-native.nvim',
                hooks = {
                    post_install = function(args)
                        later(function() build(args) end)
                    end,
                    post_checkout = build,
                },
            },
        },
    })

    source('telescope.lua')
end)

later(function()
    add({
        source = 'mfussenegger/nvim-dap',
        depends = {
            { source = 'nvim-lua/plenary.nvim' },
            { source = 'nvim-neotest/nvim-nio' },
            { source = 'rcarriga/nvim-dap-ui' },
            { source = 'nvim-treesitter/nvim-treesitter' },
        },
    })

    source('debug.lua')
end)

---
--- Development Plugins
---

require('mini.deps').later(function()
    require('mini.deps').add({
        source = 'crnvl96/lazydocker.nvim',
        checkout = 'v2.0.0',
    })

    require('lazydocker').setup()
end)
