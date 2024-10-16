pcall(function() vim.loader.enable() end)

local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })
local now, later = MiniDeps.now, MiniDeps.later

now(function() require('config.opts') end)
now(function() require('config.keymaps') end)
now(function() require('config.autocmds') end)

now(function() require('plugins.minibase16') end)
now(function() require('plugins.miniicons') end)

now(function() require('plugins.telescope') end)
now(function() require('plugins.minicompletion') end)

later(function() require('plugins.mason') end)
later(function() require('plugins.treesitter') end)
later(function() require('plugins.lspconfig') end)

later(function() require('plugins.conform') end)
later(function() require('plugins.dap') end)

later(function() require('plugins.oil') end)
later(function() require('plugins.fugitive') end)
later(function() require('plugins.minidoc') end)

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
