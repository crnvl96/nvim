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

local now, ltr = deps.now, deps.later

local function rc(modname)
    return function() require('config.' .. modname) end
end

local function rp(modname)
    return function() require('plugins.' .. modname) end
end

now(rc('opts'))
now(rc('autocmds'))
now(rc('keymaps'))

now(rp('plenary'))
now(rp('nvim-nio'))

now(rp('colorscheme'))
now(rp('mason'))
now(rp('mini-misc'))
now(rp('mini-bufremove'))
now(rp('treesitter'))
now(rp('mini-ai'))

now(rp('grug-far'))
now(rp('oil'))
now(rp('fzf-lua'))

now(rp('conform'))
now(rp('cmp'))
now(rp('lsp'))

now(rp('dap'))
ltr(rp('gitsigns'))
ltr(rp('fugitive'))

ltr(rp('quicker'))
ltr(rp('bqf'))

ltr(rp('vim-tmux-navigator'))

ltr(rp('clue'))
