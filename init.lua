local Config = require('config')

local mini_path = Config.path.package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd([[echo "Installing 'mini.nvim'" | redraw]])
    local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
    vim.fn.system(clone_cmd)
end

local deps = require('mini.deps')
deps.setup({ path = { package = Config.path.package } })

local add, now, later = deps.add, deps.now, deps.later

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
    o.timeoutlen = 200
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
    vim.opt.fillchars:append('vert:║,horiz:═,horizdown:╦,horizup:╩,verthoriz:╬,vertleft:╣,vertright:╠')
end)

now(function()
    local gr = function(name) vim.api.nvim_create_augroup(name or 'Crnvl96DefaultGroup', {}) end
    local au = function(event, pattern, callback, desc)
        vim.api.nvim_create_autocmd(event, { group = gr(), pattern = pattern, callback = callback, desc = desc })
    end

    au('TextYankPost', '*', function() vim.highlight.on_yank() end, 'Highlight yanked text')

    au('LspAttach', '*', function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        Config.lsp.on_attach(client, e.buf)
    end, 'Lsp attach function')

    au(
        'User',
        'MiniFilesWindowOpen',
        function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'double' }) end,
        'Setup MiniFiles window config'
    )
end)

now(function()
    local misc = require('mini.misc')

    misc.setup({
        make_global = {
            'put',
            'put_text',
            'stat_summary',
            'bench_time',
        },
    })

    misc.setup_restore_cursor()
    misc.setup_termbg_sync()
    misc.setup_auto_root()
end)

now(function()
    local icons = require('mini.icons')
    icons.setup({
        use_file_extension = function(ext, _)
            local suf3, suf4 = ext:sub(-3), ext:sub(-4)
            return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
        end,
    })

    later(icons.mock_nvim_web_devicons)
    later(icons.tweak_lsp_kind)
end)

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

now(function() require('mini.extra').setup() end)

now(function()
    -- stylua: ignore
    add({ source = 'williamboman/mason.nvim', hooks = { post_checkout = function() vim.cmd('MasonUpdate') end } })
    add('williamboman/mason-lspconfig.nvim')
    add('neovim/nvim-lspconfig')

    now(function() Config.lsp.setup_dynamic_capabilities(Config.lsp.on_attach) end)

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
                server.capabilities = Config.lsp.capabilities
                require('lspconfig')[server_name].setup(server)
            end,
        },
    })
end)

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

now(function() require('mini.bufremove').setup() end)

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

later(function() add('tpope/vim-fugitive') end)

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
--- File explorer
---

later(
    function()
        require('mini.files').setup({
            windows = {
                preview = true,
                width_preview = 80,
            },
            mappings = {
                go_in = '',
                go_in_plus = '<CR>',
                go_out = '',
                go_out_plus = '-',
            },
        })
    end
)

---
--- General picker (fd, grep, lsp...)
---

later(function()
    require('mini.visits').setup()

    require('mini.pick').setup({
        options = {
            use_cache = true,
        },
        window = {
            config = {
                border = 'double',
            },
            prompt_cursor = '_',
            prompt_prefix = '',
        },
    })

    vim.ui.select = require('mini.pick').ui_select
end)

---
--- Debugging tools
---

later(function()
    add('nvim-neotest/nvim-nio')
    add('nvim-lua/plenary.nvim')
    add('mfussenegger/nvim-dap-python')
    add('jbyuki/one-small-step-for-vimkind')
    add('rcarriga/nvim-dap-ui')
    add('mfussenegger/nvim-dap')

    Config.plugins.dap.bootstrap()
    Config.plugins.dap.setup.lua()
    Config.plugins.dap.setup.python()
    Config.plugins.dap.setup.javascript()
end)

---
--- Development focused plugins
---

later(function()
    add('danymat/neogen')

    require('mini.test').setup()
    require('mini.doc').setup()

    require('neogen').setup({
        languages = {
            lua = { template = { annotation_convention = 'emmylua' } },
            python = { template = { annotation_convention = 'numpydoc' } },
        },
    })
end)

---
--- Keymaps
---

later(function()
    local set = vim.keymap.set

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
    set('n', '-', '<cmd>lua MiniFiles.open()<CR>')
    set('n', '<leader>ff', '<cmd>Pick files<CR>', { desc = 'Pick files' })
    set('n', '<leader>fk', '<cmd>Pick keymaps<CR>', { desc = 'Pick keymaps' })
    set('n', '<leader>fl', "<cmd>Pick buf_lines scope='current'<CR>", { desc = 'Pick buflines' })
    set('n', '<leader>fo', '<cmd>Pick visit_paths<CR>', { desc = 'Pick visit paths' })
    set('n', '<leader>fg', '<cmd>Pick grep_live<CR>', { desc = 'Pick grep' })
    set('n', '<leader>fh', '<cmd>Pick help<CR>', { desc = 'Pick help' })
    set('n', '<leader>fr', '<cmd>Pick resume<CR>', { desc = 'Pick resume' })
    set('n', '<leader>fb', '<cmd>Pick buffers<CR>', { desc = 'Pick buffers' })
    set('n', '<C-b>', '<cmd>Pick buffers<CR>', { desc = 'Pick buffers' })
    set('n', '<leader>bd', '<cmd>lua MiniBufremove.delete(0, false)<CR>', { desc = 'Delete current buffer' })
    set('n', '<leader>bo', Config.delete_other_buffers, { desc = 'Delete all other buffers ' })
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
