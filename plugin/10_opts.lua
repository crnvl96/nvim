---@diagnostic disable: undefined-global

local now = MiniDeps.now

now(function()
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- Default nodejs path for nvim
  local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24.12.0/bin'
  vim.env.PATH = node_bin .. ':' .. vim.env.PATH
  vim.g.node_host_prog = node_bin .. '/node'

  -- stylua: ignore start
  vim.o.mouse = 'a'                                   -- Enable mouse in all modes
  vim.o.mousescroll = 'ver:1,hor:2'                   -- Make mouse scroll more smoothly
  vim.o.undofile = true                               -- Persistent undo
  vim.o.laststatus = 0                                -- No statusline
  vim.o.clipboard = 'unnamedplus'                     -- Sync with system clipboard
  vim.o.swapfile = false                              -- Disable swap
  vim.o.ruler = false                                 -- No ruler
  vim.o.showcmd = false                               -- Don't echo the cmd
  vim.o.breakindent = true                            -- Keep line breaks visually indented
  vim.o.linebreak = true                              -- Break lines at word boundaries
  vim.o.number = true                                 -- Enable line numbers
  vim.o.relativenumber = true                         -- Make line numbers relative
  vim.o.signcolumn = 'yes'                            -- Keep signcol always visible
  vim.o.splitbelow = true                             -- Prever below splits
  vim.o.splitright = true                             -- Prefer right splits
  vim.o.winborder = 'single'                          -- Prefer 'single' borders
  vim.o.wrap = false                                  -- Don't auto break lines
  vim.o.scrolloff = 8                                 -- Vertical cursor margin
  vim.o.autoindent = true                             -- Keep indenting of current line when starting a new line 
  vim.o.expandtab = true                              -- Convert tabs into spaces
  vim.o.ignorecase = true                             -- Ignore case in search patterns
  vim.o.incsearch = true                              -- Show pattern matches gradually when typing
  vim.o.infercase = true                              -- Smart case guessing algorithm on completion
  vim.o.shiftwidth = 4                                -- How many spaces each step of indentation counts for
  vim.o.smartcase = true                              -- Override 'ignorecase' if pattern contains upper case chars
  vim.o.smartindent = true                            -- Smarter indenting
  vim.o.tabstop = 4                                   -- How many spaces a tab count for
  vim.o.virtualedit = 'block'                         -- Allow rectangle selection of text
  vim.o.complete    = '.'                             -- Use less sources
  vim.o.completeopt = 'menuone,noselect,fuzzy,nosort' -- Completion options
  -- stylua: ignore end

  vim.cmd 'filetype plugin indent on'
  if vim.fn.exists 'syntax_on' ~= 1 then vim.cmd 'syntax enable' end
end)
