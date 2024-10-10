---
--- Utilities
---

local Config = require('config')

---
--- Package manager setup
---

local mini_path = Config.path.package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd([[echo "Installing 'mini.nvim'" | redraw]])
    local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
    vim.fn.system(clone_cmd)
end

local deps = require('mini.deps')
deps.setup({ path = { package = Config.path.package } })

---
--- Aliases / Helpers
---

local add, now, later = deps.add, deps.now, deps.later
local set = vim.keymap.set
local gr = function(name) vim.api.nvim_create_augroup(name or 'Crnvl96DefaultGroup', {}) end
local au = function(event, pattern, callback, name)
    vim.api.nvim_create_autocmd(event, { group = gr(name), pattern = pattern, callback = callback, desc = name })
end

---
--- Opts
---

now(function()
    local o = vim.o
    local opt = vim.opt
    local g = vim.g

    g.mapleader = ' '
    g.maplocalleader = ','
    o.mouse = 'a'
    o.guicursor = ''
    o.splitkeep = 'screen'
    o.relativenumber = true
    o.timeoutlen = 1000
    o.swapfile = false
    o.shiftwidth = 2
    o.scrolloff = 8
    o.pumblend = 0
    o.winblend = 0
    o.list = false
    o.background = 'dark'
    o.formatexpr = "v:lua.require'conform'.formatexpr()"
    o.undofile = true
    o.backup = false
    o.writebackup = false
    o.breakindent = true
    o.cursorline = true
    o.linebreak = true
    o.number = true
    o.switchbuf = 'uselast'
    o.splitbelow = true
    o.splitright = true
    o.ruler = false
    o.showmode = false
    o.wrap = false
    o.signcolumn = 'yes'
    o.ignorecase = true
    o.incsearch = true
    o.infercase = true
    o.smartcase = true
    o.smartindent = true
    o.completeopt = 'menuone,noinsert,noselect'
    o.virtualedit = 'block'
    o.formatoptions = 'qjl1'
    o.termguicolors = true
    o.clipboard = 'unnamedplus'

    opt.shortmess:append('WcC')

    if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end

    vim.cmd('filetype plugin indent on')
    vim.cmd('packadd cfilter')
    if vim.fn.exists('syntax_on') ~= 1 then vim.cmd([[syntax enable]]) end
end)

---
--- Keymaps
---

later(function()
    set('x', 'p', 'P')
    set('n', '-', '<cmd>Ex<CR>', { desc = 'Netrw' })
    set('n', '<C-H>', '<C-w>h', { desc = 'Focus on left window' })
    set('n', '<C-J>', '<C-w>j', { desc = 'Focus on below window' })
    set('n', '<C-K>', '<C-w>k', { desc = 'Focus on above window' })
    set('n', '<C-L>', '<C-w>l', { desc = 'Focus on right window' })
    set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
    set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
    set('n', '<C-S>', '<Cmd>silent! update | redraw<CR>', { desc = 'Save' })
    set({ 'i', 'x' }, '<C-S>', '<Esc><Cmd>silent! update | redraw<CR>', { desc = 'Save and go to Normal mode' })
    set({ 'n', 'x', 'i' }, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { desc = 'Better Esc' })
    set({ 'n', 'x' }, '<c-d>', '<c-d>zz', { desc = 'Move window down and center' })
    set({ 'n', 'x' }, '<c-u>', '<c-u>zz', { desc = 'Move window up and center' })
    set('n', '<c-up>', '<Cmd>resize +5<CR>', { desc = 'Increase window height' })
    set('n', '<c-down>', '<Cmd>resize -5<CR>', { desc = 'Decrease window height' })
    set('n', '<c-left>', '<Cmd>vertical resize -20<CR>', { desc = 'Increase window width' })
    set('n', '<c-right>', '<Cmd>vertical resize +20<CR>', { desc = 'Decrease window width' })
    set('x', '<', '<gv', { desc = 'Indent visually selected lines' })
    set('x', '>', '>gv', { desc = 'Dedent visually selected lines' })
    set('n', '[[', '<cmd>cprev<cr>zvzz', { desc = 'Previous quickfix item' })
    set('n', ']]', '<cmd>cnext<cr>zvzz', { desc = 'Next quickfix item' })
end)

---
--- Autocommands
---

now(function()
    au('TextYankPost', '*', function() vim.highlight.on_yank() end, 'Highlight yanked text')

    au(
        'User',
        'MiniFilesWindowOpen',
        function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'double' }) end,
        'Setup MiniFiles window config'
    )

    au('LspAttach', '*', function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        Config.lsp.on_attach(client, e.buf)
    end, 'Attach lsp keymaps')

    au('BufReadPre', '*', function(e)
        local ignore = { 'gitcommit', 'gitrebase' }
        local center = true
        vim.api.nvim_create_autocmd('FileType', {
            buffer = e.buf,
            once = true,
            callback = function()
                if vim.bo.buftype ~= '' then return end
                if vim.tbl_contains(ignore, vim.bo.filetype) then return end
                local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
                if cursor_line > 1 then return end
                local mark_line = vim.api.nvim_buf_get_mark(0, [["]])[1]
                local n_lines = vim.api.nvim_buf_line_count(0)
                if not (1 <= mark_line and mark_line <= n_lines) then return end
                vim.cmd([[normal! g`"zv]])
                if center then vim.cmd('normal! zz') end
            end,
        })
    end, 'Setup restore cursor')

    au('QuickFixCmdPost', '[^lc]*', function() vim.cmd('cwindow') end, 'Auto open qflist')
    au('QuickFixCmdPost', 'l*', function() vim.cmd('lwindow') end, 'Auto open loclist')
end)

---
--- LSP Dynamic capabilities registration
---

now(function() Config.lsp.setup_dynamic_capabilities(Config.lsp.on_attach) end)

---
--- Git integration
---

later(function() add('tpope/vim-fugitive') end)

---
--- Colorscheme
---

now(
    function()
        require('mini.hues').setup({
            background = '#0F111A',
            foreground = '#A6ACCD',
            n_hues = 8,
            saturation = 'medium',
        })
    end
)

---
--- Completion
---

later(function()
    require('mini.completion').setup({
        lsp_completion = {
            source_func = 'omnifunc',
            auto_setup = false,
            process_items = function(items, base)
                -- Don't show 'Text' and 'Snippet' suggestions
                items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
                return require('mini.completion').default_process_items(items, base)
            end,
        },
        window = {
            info = { border = 'double' },
            signature = { border = 'double' },
        },
    })

    if vim.fn.has('nvim-0.11') == 1 then vim.opt.completeopt:append('fuzzy') end
end)

---
--- Lsp
---

now(function()
    -- stylua: ignore
    add({ source = 'williamboman/mason.nvim', hooks = { post_checkout = function() vim.cmd('MasonUpdate') end } })
    add('williamboman/mason-lspconfig.nvim')
    add('neovim/nvim-lspconfig')

    require('mason').setup()

    require('mason-registry').refresh(function()
        for _, tool in ipairs(Config.plugins.mason.tools) do
            local pkg = require('mason-registry').get_package(tool)
            if not pkg:is_installed() then pkg:install() end
        end
    end)

    require('mason-lspconfig').setup({
        ensure_installed = vim.tbl_keys(Config.lsp.servers),
        handlers = {
            function(server_name)
                local server = Config.lsp.servers[server_name] or {}
                server.capabilities = Config.lsp.capabilities()
                require('lspconfig')[server_name].setup(server)
            end,
        },
    })
end)

---
--- Treesitter
---

now(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })

    require('nvim-treesitter.configs').setup({
        ensure_installed = Config.plugins.treesitter.parsers,
        highlight = {
            enable = true,
            disable = function(_, bufnr)
                if not vim.bo[bufnr].modifiable then return false end
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
                return ok and stats and stats.size > 1024 * 250
            end,
        },
        indent = { enable = true },
        incremental_selection = { enable = false },
    })
end)

---
--- Formatter
---

later(function()
    add('stevearc/conform.nvim')

    require('conform').setup({
        notify_on_error = false,
        formatters_by_ft = Config.plugins.conform.formatters_by_ft(Config.plugins.conform.get_first_formatter),
        formatters = {
            injected = {
                options = {
                    ignore_errors = true,
                },
            },
        },
        format_on_save = {
            timeout_ms = 1000,
            lsp_format = 'fallback',
        },
    })
end)

---
--- FZF
---

later(function()
    -- add({ source = 'junegunn/fzf', hooks = { post_checkout = function() vim.fn['fzf#install']() end } })
    -- add('junegunn/fzf.vim')

    add('ibhagwan/fzf-lua')
    require('fzf-lua').setup({ 'telescope' })

    set('n', '<leader>ff', '<cmd>FzfLua files<CR>', { desc = 'Files' })
    set('n', '<leader>fg', '<cmd>FzfLua grep_project<CR>', { desc = 'Grep' })
    set('n', '<leader>fh', '<cmd>FzfLua helptags<CR>', { desc = 'Help' })
    set('n', '<leader>fl', '<cmd>FzfLua blines<CR>', { desc = 'lines' })
end)

---
--- Debugging tools
---

later(function()
    add('nvim-neotest/nvim-nio')
    add('mfussenegger/nvim-dap-python')
    add('jbyuki/one-small-step-for-vimkind')
    add('rcarriga/nvim-dap-ui')
    add('mfussenegger/nvim-dap')

    Config.plugins.dap.bootstrap()
    Config.plugins.dap.setup.lua()
    Config.plugins.dap.setup.python()
    Config.plugins.dap.setup.javascript()

    set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Set breakpoint' })
    set('n', '<Leader>dc', function() require('dap').continue() end, { desc = 'Dap continue' })
    set('n', '<Leader>dt', function() require('dap').terminate() end, { desc = 'Dap terminate session' })
    set('n', '<Leader>du', function() require('dapui').toggle() end, { desc = 'Dap UI' })
    set('n', '<Leader>de', function() require('dapui').eval(nil, { enter = true }) end, { desc = 'Dap Eval' })
end)

---
--- Development Plugins
---

MiniDeps.later(function()
    MiniDeps.add({
        source = 'crnvl96/lazydocker.nvim',
        checkout = 'v2.0.0',
    })

    require('lazydocker').setup()
end)
