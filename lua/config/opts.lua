vim.g.mapleader = ' ' -- Use <Space> as leader key
vim.g.maplocalleader = ',' -- Use `,` as localleader key
vim.g.whoami = 'crnvl96' -- Default name to use in autocmds
vim.g.bigfile_size = 1024 * 250 -- 250 KB

vim.o.splitbelow = true -- Open new windows below the existing ones
vim.o.splitright = true -- Open new windows to the right the existing ones
vim.o.cursorline = true -- Highlight the current line
vim.o.showcmd = false -- Show current cmd being executed
vim.o.showmode = false -- Show current active mode
vim.o.ruler = false -- Show current cursor position
vim.o.laststatus = 0 -- Show the statusline
vim.o.foldcolumn = '0' -- When and how to draw the foldcolumn. "0": To disable foldcolumn
vim.o.foldenable = false -- When off, all folds are open
vim.o.foldlevel = 99 -- Sets the fold level: Folds with a higher level will be closed
vim.o.foldlevelstart = 99 -- Always starts with no folds closed
vim.o.foldmethod = 'expr' -- 'foldexpr' gives the fold level of a line.
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Sets treesitter as the fold controller source
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- Use conform as formatter tool for `gq`
vim.o.swapfile = false -- Disable swapfile
vim.o.virtualedit = 'block' -- Use `reactangle selection` in visual mode
vim.o.splitkeep = 'screen' -- Remove window scrill in horizontal splits
vim.o.shiftround = true -- Round indent to multiple of 'shiftwidth'
vim.o.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.o.tabstop = 2 -- Sets <Tab> to be equivalent to 2 spaces
vim.o.expandtab = true -- Converts tabs into spaces
vim.o.scrolloff = 8 -- Amount of lines to surround the cursor
vim.o.sidescrolloff = 4 -- Amount of lines to surround the cursor horizontally
vim.o.breakindent = true -- Every wrapped line will continue visually indented
vim.o.smartindent = true -- Respect indentation when creating new lines
vim.o.ignorecase = true -- Perform case insensitive searches
vim.o.smartcase = true --  Override the 'ignorecase' option if the search pattern contains upper case characters
vim.o.mouse = 'a' -- Enable mouse usage in all modes
vim.o.number = true -- Enable line numbers
vim.o.relativenumber = true -- Enable relative line numbers
vim.o.clipboard = 'unnamedplus' -- Use system clipboard
vim.o.signcolumn = 'yes' -- Always show the sign column
vim.o.fillchars = 'eob: ' -- Disable some unwanted signs
vim.o.termguicolors = true -- Enable 24-bit RGB color support
vim.o.undofile = true -- Enable persistend undo across sessions
vim.o.updatetime = 300 --  If this many milliseconds nothing is typed the swap file will be written to disk.  Also used for the CursorHold autocmd.
vim.o.timeoutlen = 200 -- Time to wait before a keymap is computed
vim.o.backup = false -- Disable Backup files
vim.o.writebackup = false -- Do not write backup files
vim.o.wrap = false -- Do now wrap lines
vim.o.linebreak = true -- If on, Vim will wrap long lines at a character in 'breakat' rather than at the last character that fits on the screen
vim.o.wildignorecase = true -- Wildmenu matches will be case insensitive
vim.o.background = 'dark' -- Dark background

vim.opt.diffopt:append('linematch:60') -- Enable a second stage diff on each generated hunk in order to align lines.
vim.opt.wildoptions:append('fuzzy') -- Fuzzy match on wildmenu
vim.opt.path:append('**') -- Recursive search
vim.opt.wildignore:append('*/node_modules/*,*/dist/*') -- Never search on these files
vim.opt.completeopt:append('menuone,noinsert,noselect,popup,fuzzy') -- Completion options

if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end -- Conditionally enables ripgrep as search engine
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end -- Enable syntax highlight

vim.cmd('filetype plugin indent on') -- Indentation
vim.cmd('packadd cfilter') -- Adds Cfilter plugin
