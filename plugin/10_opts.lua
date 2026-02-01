---@diagnostic disable: undefined-global

local now = MiniDeps.now

now(function()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ','

    -- Default nodejs path for nvim
    local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24.12.0/bin'

    vim.env.PATH = node_bin .. ':' .. vim.env.PATH
    vim.g.node_host_prog = node_bin .. '/node'

    vim.o.mouse = 'a'
    vim.o.mousescroll = 'ver:1,hor:2'
    vim.o.undofile = true
    vim.o.laststatus = 0
    vim.o.clipboard = 'unnamedplus'
    vim.o.swapfile = false
    vim.o.ruler = false
    vim.o.showcmd = false
    vim.o.breakindent = true
    vim.o.linebreak = true
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.signcolumn = 'yes'
    vim.o.splitbelow = true
    vim.o.splitright = true
    vim.o.winborder = 'single'
    vim.o.wrap = false
    vim.o.scrolloff = 8
    vim.o.autoindent = true
    vim.o.expandtab = true
    vim.o.ignorecase = true
    vim.o.incsearch = true
    vim.o.infercase = true
    vim.o.shiftwidth = 4
    vim.o.smartcase = true
    vim.o.smartindent = true
    vim.o.tabstop = 4
    vim.o.virtualedit = 'block'
    vim.o.complete = '.'
    vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'
    vim.o.wildoptions = 'fuzzy,pum,tagfile'

    vim.cmd 'filetype plugin indent on'

    if vim.fn.executable 'rg' then
        vim.o.grepprg = 'rg --vimgrep --no-heading --hidden --smart-case'
        vim.opt.grepformat = '%f:%l:%c:%m'
    end

    if vim.fn.exists 'syntax_on' ~= 1 then
        vim.cmd 'syntax enable'
    end
end)
