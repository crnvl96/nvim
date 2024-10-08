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

local minideps = require('mini.deps')
minideps.setup({ path = { package = path_package } })

local add = minideps.add
local now = minideps.now
local later = minideps.later

now(function() require('config.opts') end)

now(function()
    add('nvim-neotest/nvim-nio')
    add('nvim-lua/plenary.nvim')
    add({ source = 'williamboman/mason.nvim', hooks = { post_checkout = function() vim.cmd('MasonUpdate') end } })
    add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_checkout = function() vim.cmd('TSUpdate') end } })
    add('williamboman/mason-lspconfig.nvim')
    add('neovim/nvim-lspconfig')
    add('stevearc/conform.nvim')
    add('mfussenegger/nvim-dap-python')
    add('jbyuki/one-small-step-for-vimkind')
    add('rcarriga/nvim-dap-ui')
    add('mfussenegger/nvim-dap')
    add('tpope/vim-fugitive')
end)

now(function() require('plugins.mason') end)
now(function() require('plugins.mini-completion') end)
now(function() require('plugins.lsp') end)

now(function() require('plugins.mini-extra') end)
now(function() require('plugins.mini-icons') end)
now(function() require('plugins.mini-misc') end)
now(function() require('plugins.mini-hues') end)
now(function() require('plugins.mini-statusline') end)
now(function() require('plugins.mini-tabline') end)
now(function() require('plugins.treesitter') end)

later(function() require('plugins.mini-pick') end)
later(function() require('plugins.mini-indentscope') end)
later(function() require('plugins.mini-bufremove') end)
later(function() require('plugins.conform') end)
later(function() require('plugins.dap') end)
later(function() require('plugins.mini-doc') end)
later(function() require('plugins.mini-test') end)

later(function() require('config.keymaps') end)

later(function()
    add({
        source = 'crnvl96/lazydocker.nvim',
        checkout = 'v2.0.0',
    })

    require('lazydocker').setup()
end)
