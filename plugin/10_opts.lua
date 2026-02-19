Config.now(function()
  local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24.12.0/bin'
  vim.env.PATH = node_bin .. ':' .. vim.env.PATH
  vim.g.node_host_prog = node_bin .. '/node'
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  vim.o.clipboard = 'unnamedplus'
  vim.o.mousescroll = 'ver:1,hor:2'
  vim.o.mouse = 'a'
  vim.o.virtualedit = 'block'
  vim.o.swapfile = false
  vim.o.undofile = true
  vim.o.updatetime = 1000
  vim.o.splitbelow = true
  vim.o.splitright = true
  vim.o.wrap = false
  vim.o.laststatus = 2
  vim.o.scrolloff = 8
  vim.o.shiftwidth = 4
  vim.o.tabstop = 4
  vim.o.autoindent = true
  vim.o.breakindent = true
  vim.o.smartcase = true
  vim.o.smartindent = true
  vim.o.completeopt = 'menu,menuone,popup,fuzzy,noinsert,noselect,nosort'
  vim.o.wildoptions = 'pum,tagfile,fuzzy'
  vim.o.completetimeout = 100
  vim.o.infercase = true
  vim.o.ignorecase = true
  vim.o.incsearch = true
  vim.o.expandtab = true
  vim.o.linebreak = true
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.ruler = false
  vim.o.showcmd = false
  vim.o.signcolumn = 'yes'
  vim.o.winborder = 'single'
  vim.o.pumborder = 'single'
  vim.o.pummaxwidth = 100

  vim.cmd('filetype plugin indent on')
  if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

  if vim.fn.executable('rg') then
    function _G.FindFuncRG(cmdarg)
      local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
      return #cmdarg == 0 and fnames or vim.fn.matchfuzzy(fnames, cmdarg)
    end

    vim.o.grepprg = 'rg --vimgrep --no-heading --hidden --smart-case'
    vim.o.grepformat = '%f:%l:%c:%m'
    vim.o.findfunc = 'v:lua.FindFuncRG'
  end
end)

Config.later(
  function()
    vim.diagnostic.config({
      signs = {
        priority = 9999,
        severity = {
          min = vim.diagnostic.severity.WARN,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      underline = {
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      virtual_lines = false,
      virtual_text = {
        current_line = true,
        severity = {
          min = vim.diagnostic.severity.ERROR,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      update_in_insert = false,
    })
  end
)
