pcall(function() vim.loader.enable() end)

-- Define main config table
_G.Config = {
    path_package = vim.fn.stdpath('data') .. '/site/',
    path_source = vim.fn.stdpath('config') .. '/src/',
}

local mini_path = Config.path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd([[echo "Installing 'mini.nvim'" | redraw]])
    local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
    vim.fn.system(clone_cmd)
end
require('mini.deps').setup({ path = { package = Config.path_package } })

local add, now, ltr = MiniDeps.add, MiniDeps.now, MiniDeps.later
local source = function(path) dofile(Config.path_source .. path) end

now(function() source('config/opts.lua') end)
now(function() source('config/keymaps.lua') end)
now(function() MiniDeps.add('nvim-neotest/nvim-nio') end)
now(function() MiniDeps.add('nvim-lua/plenary.nvim') end)

now(function() source('mini/basics.lua') end)
now(function() require('mini.statusline').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.extra').setup() end)

ltr(function() require('mini.bracketed').setup() end)
ltr(function() require('mini.trailspace').setup() end)
ltr(function() require('mini.visits').setup() end)
ltr(function() require('mini.diff').setup() end)
ltr(function() require('mini.git').setup() end)
ltr(function() require('mini.indentscope').setup() end)
ltr(function() require('mini.bufremove').setup() end)
ltr(function() require('mini.doc').setup() end)
ltr(function() require('mini.test').setup() end)

now(function() source('mini/misc.lua') end)
now(function() source('mini/hues.lua') end)
now(function() source('mini/icons.lua') end)
now(function() source('mini/notify.lua') end)

ltr(function() source('mini/clue.lua') end)
ltr(function() source('mini/completion.lua') end)
ltr(function() source('mini/files.lua') end)
ltr(function() source('mini/operators.lua') end)
ltr(function() source('mini/jump.lua') end)
ltr(function() source('mini/hipatterns.lua') end)
ltr(function() source('mini/pick.lua') end)

ltr(function() source('mason.lua') end)
ltr(function() source('lsp.lua') end)
ltr(function() source('treesitter.lua') end)
ltr(function() source('conform.lua') end)
ltr(function() source('dap.lua') end)
ltr(function() source('neogen.lua') end)

ltr(function()
    add({
        source = 'crnvl96/lazydocker.nvim',
        checkout = 'v2.0.0',
    })

    require('lazydocker').setup()
end)
