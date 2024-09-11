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

require('mini.deps').now(function() require('config.opts') end)
require('mini.deps').now(function() require('config.keymaps') end)
require('mini.deps').now(function() require('config.autocmds') end)

require('mini.deps').now(function() require('plugins.colorscheme') end)
require('mini.deps').now(function() require('plugins.icons') end)

require('mini.deps').now(function() require('langs.go') end)
require('mini.deps').now(function() require('langs.typescript') end)
require('mini.deps').now(function() require('langs.lua') end)

require('mini.deps').now(function() require('plugins.completion') end)
require('mini.deps').now(function() require('plugins.dap') end)
require('mini.deps').now(function() require('plugins.lsp') end)
require('mini.deps').now(function() require('plugins.treesitter') end)
require('mini.deps').now(function() require('plugins.formatter') end)

require('mini.deps').later(function() require('plugins.tmux') end)
require('mini.deps').later(function() require('plugins.fugitive') end)
require('mini.deps').later(function() require('plugins.grugfar') end)
require('mini.deps').later(function() require('plugins.oil') end)
require('mini.deps').later(function() require('plugins.fzflua') end)
require('mini.deps').later(function() require('plugins.clue') end)
