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

local now, later = minideps.now, minideps.later

---@param modname string
---@return function
local function rc(modname)
    return function() require('config.' .. modname) end
end

---@param modname string
---@return function
local function rp(modname)
    return function() require('plugins.' .. modname) end
end

now(rc('opts'))
now(rc('keymaps'))
now(rc('autocmds'))

now(rp('theme'))
now(rp('dependencies'))
now(rp('lsp'))

later(rp('mini-pick'))
later(rp('debug'))
later(rp('git'))
