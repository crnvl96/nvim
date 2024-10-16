pcall(function() vim.loader.enable() end)

local on_lsp_attach = function(client, bufnr)
    local map = function(method, lhs, rhs, desc, mode)
        local setmap = function() vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr }) end
        if client.supports_method(method) then setmap() end
    end

    vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    local m = vim.lsp.protocol.Methods

    local wrap = function(mod)
        mod = 'lsp_' .. mod
        return function() require('telescope.builtin')[mod](require('telescope.themes').get_ivy()) end
    end

    -- stylua: ignore start
    map(m.textDocument_definition, 'gd', wrap('definitions'), 'Go to definition')
    map(m.textDocument_references, 'gR', wrap('references'), 'List references')
    map(m.textDocument_implementation, 'gi', wrap('implementations'), 'List implementations')
    map(m.textDocument_typeDefinition, 'gy', wrap('type_definitions'), 'Go to type definition')
    map(m.textDocument_codeAction, 'ga', vim.lsp.buf.code_action, 'List code actions')
    map(m.textDocument_rename, 'gn', vim.lsp.buf.code_action, 'Rename symbol under cursor')
    -- stylua: ignore end
end

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
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ','
    vim.o.backup = false
    vim.o.mouse = 'a'
    vim.o.guicursor = ''
    vim.o.switchbuf = 'usetab'
    vim.o.writebackup = false
    vim.o.undofile = true
    vim.o.clipboard = 'unnamedplus'
    vim.o.breakindent = true
    vim.o.cursorline = true
    vim.o.laststatus = 2
    vim.o.linebreak = true
    vim.o.number = true
    vim.o.autoread = true
    vim.o.relativenumber = true
    vim.o.ruler = false
    vim.o.showmode = false
    vim.o.showtabline = 0
    vim.o.splitbelow = true
    vim.o.splitright = true
    vim.o.termguicolors = true
    vim.o.wrap = false
    vim.o.cmdheight = 1
    vim.o.scrolloff = 8
    vim.o.cursorlineopt = 'screenline,number'
    vim.o.breakindentopt = 'list:-1'
    vim.o.autoindent = true
    vim.o.expandtab = true
    vim.o.formatoptions = 'rqnl1j'
    vim.o.ignorecase = true
    vim.o.incsearch = true
    vim.o.infercase = true
    vim.o.shiftwidth = 2
    vim.o.smartcase = true
    vim.o.smartindent = true
    vim.o.tabstop = 2
    vim.o.virtualedit = 'block'
    vim.o.timeoutlen = 1000
    vim.o.signcolumn = 'yes'
    vim.o.foldmethod = 'indent'
    vim.o.foldlevel = 1
    vim.o.foldnestmax = 10
    vim.o.foldlevelstart = 99
    vim.o.foldtext = ''
    vim.o.splitkeep = 'screen'
    vim.o.shortmess = 'aoOWFcSC'

    vim.opt.completeopt:append('fuzzy')
    vim.opt.diffopt:append('linematch:60')

    if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
    if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end

    vim.cmd('filetype plugin indent on')
    vim.cmd('packadd cfilter')

    vim.diagnostic.config({ signs = false })

    vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
    vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

    vim.keymap.set({ 'n', 'x', 'i' }, '<Esc>', '<Esc><Cmd>noh<CR><Esc>')

    vim.keymap.set({ 'i', 'x' }, '<C-s>', '<Esc><Cmd>silent! update | redraw<CR>')
    vim.keymap.set({ 'n', 'x' }, '<c-d>', '<c-d>zz')
    vim.keymap.set({ 'n', 'x' }, '<c-u>', '<c-u>zz')

    vim.keymap.set('n', '-', '<cmd>Ex<CR>')
    vim.keymap.set('i', ',            ', ', <c-g>u')
    vim.keymap.set('i', '.', '.<c-g>u')
    vim.keymap.set('i', ';', ';<c-g>u')
    vim.keymap.set('x', 'p', 'P')
    vim.keymap.set('n', '<C-h>', '<C-w>h')
    vim.keymap.set('n', '<C-j>', '<C-w>j')
    vim.keymap.set('n', '<C-k>', '<C-w>k')
    vim.keymap.set('n', '<C-l>', '<C-w>l')
    vim.keymap.set('n', '<C-s>', '<Cmd>silent! update | redraw<CR>')
    vim.keymap.set('n', '<c-up>', '<Cmd>resize +5<CR>')
    vim.keymap.set('n', '<c-down>', '<Cmd>resize -5<CR>')
    vim.keymap.set('n', '<c-left>', '<Cmd>vertical resize -20<CR>')
    vim.keymap.set('n', '<c-right>', '<Cmd>vertical resize +20<CR>')
    vim.keymap.set('x', '<', '<gv')
    vim.keymap.set('x', '>', '>gv')
    vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')
    vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>')
    vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>')
    vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>')
    vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>')
    vim.keymap.set('t', '<C-w>c', '<cmd>close<cr>')
    vim.keymap.set('t', '<c-_>', '<cmd>close<cr>')

    vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
        group = vim.api.nvim_create_augroup('Crnvl96CheckTime', {}),
        callback = function()
            if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
        end,
    })

    vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('Crnvl96HighlightOnYank', {}),
        callback = function() vim.highlight.on_yank() end,
    })

    vim.api.nvim_create_autocmd({ 'VimResized' }, {
        group = vim.api.nvim_create_augroup('Crnvl96AutoResize', {}),
        callback = function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd('tabdo wincmd =')
            vim.cmd('tabnext ' .. current_tab)
        end,
    })

    vim.api.nvim_create_autocmd('BufReadPost', {
        group = vim.api.nvim_create_augroup('Crnvl96GoToLastLoc', {}),
        callback = function(event)
            local exclude = { 'gitcommit' }
            local buf = event.buf
            if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].has_done_last_loc then return end
            vim.b[buf].has_done_last_loc = true
            local mark = vim.api.nvim_buf_get_mark(buf, '"')
            local lcount = vim.api.nvim_buf_line_count(buf)
            if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
        end,
    })

    vim.api.nvim_create_autocmd('VimEnter', {
        group = vim.api.nvim_create_augroup('Crnvl96RegisterDynamicCapabilities', {}),
        callback = function()
            local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
            vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                if not client then return end
                on_lsp_attach(client, vim.api.nvim_get_current_buf())
                return registerCapability(err, res, ctx)
            end
        end,
    })

    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('Crnvl96DisableCompletion', {}),
        pattern = { 'clap_input' },
        callback = function(e) vim.b[e.buf].minicompletion_disable = true end,
    })

    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('Crnvl96CloseWithQ', {}),
        pattern = { 'fugitive', 'fugitiveblame', 'gitcommit', 'gitrebase', 'qf' },
        callback = function(e) vim.keymap.set('n', 'q', '<cmd>close!<CR>', { buffer = e.buf }) end,
    })

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('Crnvl96LspOnAttach', {}),
        callback = function(e)
            local client = vim.lsp.get_client_by_id(e.data.client_id)
            if not client then return end
            on_lsp_attach(client, e.buf)
        end,
    })
end)

now(
    function()
        require('mini.base16').setup({
            palette = {
                base00 = '#181818',
                base01 = '#282828',
                base02 = '#383838',
                base03 = '#585858',
                base04 = '#b8b8b8',
                base05 = '#d8d8d8',
                base06 = '#e8e8e8',
                base07 = '#f8f8f8',
                base08 = '#ab4642',
                base09 = '#dc9656',
                base0A = '#f7ca88',
                base0B = '#a1b56c',
                base0C = '#86c1b9',
                base0D = '#7cafc2',
                base0E = '#ba8baf',
                base0F = '#a16946',
            },
        })
    end
)

now(function()
    require('mini.icons').setup({
        use_file_extension = function(ext, _)
            local suf3, suf4 = ext:sub(-3), ext:sub(-4)
            return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
        end,
    })
    require('mini.icons').mock_nvim_web_devicons()
    later(require('mini.icons').tweak_lsp_kind)
end)

now(function()
    add({
        source = 'williamboman/mason.nvim',
        hooks = {
            post_checkout = function() vim.cmd('MasonUpdate') end,
        },
    })

    require('mason').setup()

    require('mason-registry').refresh(function()
        for _, tool in ipairs({
            'stylua',
            'prettierd',
            'js-debug-adapter',
        }) do
            local pkg = require('mason-registry').get_package(tool)
            if not pkg:is_installed() then pkg:install() end
        end
    end)
end)

now(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        hooks = {
            post_checkout = function() vim.cmd('TSUpdate') end,
        },
    })

    require('nvim-treesitter.configs').setup({
        -- stylua: ignore
        ensure_installed = { 'bash', 'c', 'gitcommit', 'html', 'javascript', 'json', 'json5', 'jsonc', 'lua',
            'markdown', 'markdown_inline', 'query', 'regex', 'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'yaml', },
        highlight = {
            enable = true,
            disable = function(_, buf)
                if not vim.bo[buf].modifiable then return false end
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                return ok and stats and stats.size > (250 * 1024)
            end,
        },
        indent = { enable = true },
    })
end)

now(function()
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
    })

    if vim.fn.has('nvim-0.11') == 1 then vim.opt.completeopt:append('fuzzy') end

    local keycode = vim.keycode or function(x) return vim.api.nvim_replace_termcodes(x, true, true, true) end

    vim.keymap.set('i', '<CR>', function()
        local pum_visible = vim.fn.pumvisible() ~= 0

        if pum_visible then
            local info = vim.fn.complete_info()
            local item_selected = info.selected ~= -1
            return item_selected and keycode('<C-y>') or keycode('<C-y><CR>')
        end

        return keycode('<CR>')
    end, { expr = true })
end)

now(function()
    add({
        source = 'neovim/nvim-lspconfig',
        depends = {
            {
                source = 'williamboman/mason-lspconfig.nvim',
                depends = {
                    { source = 'williamboman/mason.nvim' },
                },
            },
        },
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local servers = {
        eslint = { settings = { format = false } },
        vtsls = {
            settings = {
                typescript = {
                    suggest = { completeFunctionCalls = true },
                    inlayHints = {
                        functionLikeReturnTypes = { enabled = true },
                        parameterNames = { enabled = 'literals' },
                        variableTypes = { enabled = true },
                    },
                },
                javascript = {
                    suggest = { completeFunctionCalls = true },
                    inlayHints = {
                        functionLikeReturnTypes = { enabled = true },
                        parameterNames = { enabled = 'literals' },
                        variableTypes = { enabled = true },
                    },
                },
                vtsls = {
                    enableMoveToFileCodeAction = true,
                    autoUseWorkspaceTsdk = true,
                    experimental = {
                        maxInlayHintLength = 30,
                        completion = {
                            enableServerSideFuzzyMatch = true,
                        },
                    },
                },
            },
        },
        lua_ls = {
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                        path = vim.split(package.path, ';'),
                    },
                    diagnostics = {
                        globals = { 'vim', 'describe', 'it', 'before_each', 'after_each' },
                        disable = { 'need-check-nil' },
                        workspaceDelay = -1,
                    },
                    workspace = {
                        ignoreSubmodules = true,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        },
    }

    require('mason-lspconfig').setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
            function(server_name)
                local server = servers[server_name] or {}
                server.capabilities = capabilities
                require('lspconfig')[server_name].setup(server)
            end,
        },
    })
end)

later(function() add('tpope/vim-fugitive') end)

later(function() require('mini.doc').setup() end)

later(function()
    add('stevearc/oil.nvim')

    require('oil').setup({
        watch_for_changes = true,
        keymaps = {
            ['g?'] = 'actions.show_help',
            ['<CR>'] = 'actions.select',
            ['<C-w>v'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
            ['<C-w>s'] = {
                'actions.select',
                opts = { horizontal = true },
                desc = 'Open the entry in a horizontal split',
            },
            ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
            ['<f4>'] = 'actions.preview',
            ['<C-c>'] = 'actions.close',
            ['<C-w>r'] = 'actions.refresh',
            ['-'] = 'actions.parent',
            ['@'] = 'actions.open_cwd',
            ['`'] = 'actions.cd',
            ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory', mode = 'n' },
            ['gs'] = 'actions.change_sort',
            ['gx'] = 'actions.open_external',
            ['g.'] = 'actions.toggle_hidden',
            ['g\\'] = 'actions.toggle_trash',
        },
        use_default_keymaps = false,
        float = { border = 'none' },
        preview = { border = 'none' },
        progress = { border = 'none' },
        ssh = { border = 'none' },
        keymaps_help = { border = 'none' },
    })

    vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })
end)

later(function()
    add({
        source = 'stevearc/conform.nvim',
        depends = {
            { source = 'williamboman/mason.nvim' },
        },
    })

    local get_first_formatter = function(buffer, ...)
        for i = 1, select('#', ...) do
            local formatter = select(i, ...)
            if require('conform').get_formatter_info(formatter, buffer).available then return formatter end
        end

        return select(1, ...)
    end

    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    require('conform').setup({
        notify_on_error = false,
        formatters_by_ft = {
            markdown = function(buf) return { get_first_formatter(buf, 'prettierd', 'prettier'), 'injected' } end,
            json = { 'prettierd', 'prettier', stop_after_first = true },
            jsonc = { 'prettierd', 'prettier', stop_after_first = true },
            json5 = { 'prettierd', 'prettier', stop_after_first = true },
            lua = { 'stylua' },
            typescript = { 'prettierd', 'prettier', stop_after_first = true },
            typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
            javascript = { 'prettierd', 'prettier', stop_after_first = true },
            javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        },
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

later(function()
    add('folke/which-key.nvim')

    require('which-key').setup({
        preset = 'helix',
        show_help = false,
        show_keys = false,
        win = {
            border = 'none',
            title = false,
        },
        delay = 200,
        icons = { mappings = false },
        spec = {
            {
                mode = { 'n', 'v' },
                { '<leader>d', group = 'DAP' },
                { '<leader>f', group = 'Files' },
            },
        },
    })
end)

later(function()
    local build = function(args)
        local obj = vim.system({ 'make', '-C', args.path }, { text = true }):wait()
        vim.print(vim.inspect(obj))
    end

    add({
        source = 'nvim-telescope/telescope.nvim',
        depends = {
            { source = 'nvim-lua/plenary.nvim' },
            { source = 'nvim-telescope/telescope-ui-select.nvim' },
            { source = 'nvim-treesitter/nvim-treesitter' },
            {
                source = 'nvim-telescope/telescope-fzf-native.nvim',
                hooks = {
                    post_install = function(args)
                        later(function() build(args) end)
                    end,
                    post_checkout = build,
                },
            },
        },
    })

    require('telescope').setup({
        defaults = {
            initial_mode = 'insert',
            mappings = {
                i = {
                    ['<f4>'] = require('telescope.actions.layout').toggle_preview,
                    ['<C-a>'] = require('telescope.actions').select_all,
                    ['<C-o>'] = require('telescope.actions').toggle_all,
                },
                n = {
                    ['<f4>'] = require('telescope.actions.layout').toggle_preview,
                    ['<C-a>'] = require('telescope.actions').select_all,
                    ['<C-o>'] = require('telescope.actions').toggle_all,
                },
            },
            preview = { hide_on_startup = true },
        },
        pickers = {
            buffers = {
                mappings = {
                    i = { ['<c-d>'] = require('telescope.actions').delete_buffer },
                    n = { ['<c-d>'] = require('telescope.actions').delete_buffer },
                },
                initial_mode = 'normal',
            },
            live_grep = { only_sort_text = true },
        },
        extensions = {
            ['ui-select'] = {
                require('telescope.themes').get_ivy({ initial_mode = 'normal' }),
            },
        },
    })

    require('telescope').load_extension('fzf')
    require('telescope').load_extension('ui-select')

    local wrap = function(mod) return require('telescope.builtin')[mod](require('telescope.themes').get_ivy()) end

    vim.keymap.set('n', '<leader>fx', function() wrap('quickfix') end, { desc = 'Quickfix' })
    vim.keymap.set('n', '<leader>ff', function() wrap('find_files') end, { desc = 'Find File (CWD)' })
    vim.keymap.set('n', '<leader>fh', function() wrap('help_tags') end, { desc = 'Find Help' })
    vim.keymap.set('n', '<leader>fH', function() wrap('highlights') end, { desc = 'Find highlight groups' })
    vim.keymap.set('n', '<leader>fM', function() wrap('man_pages') end, { desc = 'Map Pages' })
    vim.keymap.set('n', '<leader>fo', function() wrap('oldfiles') end, { desc = 'Open Recent File' })
    vim.keymap.set('n', '<leader>fR', function() wrap('registers') end, { desc = 'Registers' })
    vim.keymap.set('n', '<leader>fg', function() wrap('grep_string') end, { desc = 'Live Grep' })
    vim.keymap.set('n', '<leader>fl', function() wrap('current_buffer_fuzzy_find') end, { desc = 'Grep lines' })
    vim.keymap.set('n', '<leader>fk', function() wrap('keymaps') end, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>fc', function() wrap('command_history') end, { desc = 'Commands' })
    vim.keymap.set('n', '<leader>fr', function() wrap('resume') end, { desc = 'Resume last search' })
    vim.keymap.set('n', '<leader>fb', function() wrap('buffers') end, { desc = 'Buffers' })
end)

later(function()
    add({
        source = 'mfussenegger/nvim-dap',
        depends = {
            { source = 'nvim-lua/plenary.nvim' },
            { source = 'nvim-neotest/nvim-nio' },
            { source = 'rcarriga/nvim-dap-ui' },
            { source = 'nvim-treesitter/nvim-treesitter' },
        },
    })

    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    local dap = require('dap')
    local dapui = require('dapui')

    dapui.setup({
        floating = { border = 'none' },
        layouts = {
            {
                elements = {
                    { id = 'stacks', size = 0.30 },
                    { id = 'breakpoints', size = 0.20 },
                    { id = 'scopes', size = 0.50 },
                },
                position = 'left',
                size = 40,
            },
        },
    })

    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close({}) end
    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close({}) end
    -- dap.defaults.fallback.terminal_win_cmd = '50vsplit new'
    dap.defaults.fallback.force_external_terminal = true
    dap.defaults.fallback.external_terminal = { command = vim.env.HOME .. '/.local/bin/kitty', args = { '-e' } }

    -- setup dap config by VsCode launch.json file
    local vscode = require('dap.ext.vscode')
    local json = require('plenary.json')
    vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end

    -- Extends dap.configurations with entries read from .vscode/launch.json
    if vim.fn.filereadable('.vscode/launch.json') then vscode.load_launchjs() end

    if not dap.adapters['pwa-node'] then
        dap.adapters['pwa-node'] = {
            type = 'server',
            host = 'localhost',
            port = '${port}',
            executable = {
                command = 'node',
                args = {
                    vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
                    '${port}',
                },
            },
        }
    end

    if not dap.adapters['node'] then
        dap.adapters['node'] = function(cb, config)
            if config.type == 'node' then config.type = 'pwa-node' end
            local nativeAdapter = dap.adapters['pwa-node']
            if type(nativeAdapter) == 'function' then
                nativeAdapter(cb, config)
            else
                cb(nativeAdapter)
            end
        end
    end

    local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

    vscode.type_to_filetypes['node'] = js_filetypes
    vscode.type_to_filetypes['pwa-node'] = js_filetypes

    for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
            dap.configurations[language] = {
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Launch file',
                    program = '${file}',
                    cwd = '${workspaceFolder}',
                },
                {
                    type = 'pwa-node',
                    request = 'attach',
                    name = 'Attach',
                    processId = require('dap.utils').pick_process,
                    cwd = '${workspaceFolder}',
                },
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Debug NPM script',
                    runtimeExecutable = 'npm',
                    runtimeArgs = function()
                        local script_name
                        vim.ui.input(
                            { prompt = 'Enter the NPM script to debug: ' },
                            function(input) script_name = input end
                        )
                        return { 'run', script_name }
                    end,
                    cwd = '${workspaceFolder}',
                    console = 'integratedTerminal',
                },
            }
        end
    end

    local eval = function() require('dapui').eval(nil, { enter = true }) end

    vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = 'Continue' })
    vim.keymap.set('n', '<leader>dC', function() require('dap').run_to_cursor() end, { desc = 'Run to Cursor' })
    vim.keymap.set('n', '<leader>dg', function() require('dap').goto_() end, { desc = 'Go to Line (No Execute)' })
    vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc = 'Step Into' })
    vim.keymap.set('n', '<leader>dj', function() require('dap').down() end, { desc = 'Down' })
    vim.keymap.set('n', '<leader>dk', function() require('dap').up() end, { desc = 'Up' })
    vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end, { desc = 'Run Last' })
    vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end, { desc = 'Step Out' })
    vim.keymap.set('n', '<leader>dO', function() require('dap').step_over() end, { desc = 'Step Over' })
    vim.keymap.set('n', '<leader>dp', function() require('dap').pause() end, { desc = 'Pause' })
    vim.keymap.set('n', '<leader>dr', function() require('dap').repl.toggle() end, { desc = 'Toggle REPL' })
    vim.keymap.set('n', '<leader>ds', function() require('dap').session() end, { desc = 'Session' })
    vim.keymap.set('n', '<leader>dt', function() require('dap').terminate() end, { desc = 'Terminate' })
    vim.keymap.set('n', '<leader>du', function() require('dapui').toggle({}) end, { desc = 'Dap UI' })
    vim.keymap.set('n', '<leader>dw', function() require('dap.ui.widgets').hover() end, { desc = 'Widgets' })
    vim.keymap.set({ 'n', 'v' }, '<leader>de', eval, { desc = 'Eval' })
end)

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
