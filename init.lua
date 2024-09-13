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

local now = deps.now

now(function()
    require('config.opts')
    require('config.keymaps')
end)

now(function() require('plugins.sources') end)

now(function()
    require('plugins.theme')
    require('plugins.tools')
    require('plugins.treesitter')
    require('plugins.debug')
    require('plugins.lsp')
    require('plugins.explorer')
end)
