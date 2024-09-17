vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.whoami = 'crnvl96'
vim.g.bigfile_size = 1024 * 250

vim.o.autoread = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.cursorline = true
vim.o.guicursor = ''
vim.o.showcmd = false
vim.o.showmode = false
vim.o.ruler = false
vim.o.laststatus = 0
vim.o.foldcolumn = '0'
vim.o.foldenable = false
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.o.swapfile = false
vim.o.virtualedit = 'block'
vim.o.splitkeep = 'screen'
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 4
vim.o.breakindent = true
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = 'unnamedplus'
vim.o.signcolumn = 'yes'
vim.o.fillchars = 'eob: '
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.updatetime = 300
vim.o.timeoutlen = 1000
vim.o.backup = false
vim.o.writebackup = false
vim.o.wrap = false
vim.o.linebreak = true
vim.o.wildignorecase = true
vim.o.background = 'dark'
vim.o.statusline = "%{repeat('─',winwidth('.'))}"

vim.opt.diffopt:append('linematch:60')
vim.opt.wildoptions:append('fuzzy')
vim.opt.path:append('**')
vim.opt.wildignore:append('*/node_modules/*,*/dist/*')
vim.opt.completeopt:append('menuone,noinsert,noselect,popup,fuzzy')

if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end

vim.cmd('packadd cfilter')

local diagnostic_icons = {
    ERROR = ' ',
    WARN = ' ',
    HINT = ' ',
    INFO = ' ',
}

vim.diagnostic.config({
    virtual_text = {
        prefix = '',
        spacing = 2,
        format = function(diagnostic)
            local special_sources = {
                ['Lua Diagnostics.'] = 'lua',
                ['Lua Syntax Check.'] = 'lua',
            }

            local source = special_sources[diagnostic.source] or diagnostic.source
            local icon = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
            return string.format('%s %s[%s] ', icon, source, diagnostic.code)
        end,
    },
    float = {
        border = 'rounded',
        source = 'if_many',
        prefix = function(diag)
            local level = vim.diagnostic.severity[diag.severity]
            local prefix = string.format(' %s ', diagnostic_icons[level])
            return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
        end,
    },
    signs = false,
})
