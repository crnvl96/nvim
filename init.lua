pcall(function() vim.loader.enable() end)

_G.Config = { path_package = vim.fn.stdpath('data') .. '/site/' }

local mini_path = Config.path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd([[echo "Installing 'mini.nvim'" | redraw]])
    local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
    vim.fn.system(clone_cmd)
end

require('mini.deps').setup({ path = { package = Config.path_package } })

MiniDeps.now(function() require('config.opts') end)
MiniDeps.now(function() require('config.keymaps') end)
MiniDeps.now(function() require('plugins.theme') end)
MiniDeps.now(function() require('plugins.lsp') end)
MiniDeps.now(function() require('plugins.settings') end)
MiniDeps.later(function() require('plugins.explorer') end)
MiniDeps.later(function() require('plugins.editor') end)
MiniDeps.later(function() require('plugins.debug') end)
MiniDeps.later(function() require('plugins.clues') end)
MiniDeps.later(function() require('plugins.git') end)
MiniDeps.later(function() require('plugins.test') end)

-- Development plugins

MiniDeps.later(function()
    MiniDeps.add({
        source = 'crnvl96/lazydocker.nvim',
        checkout = 'v2.0.0',
    })

    require('lazydocker').setup()
end)
