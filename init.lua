pcall(function() vim.loader.enable() end)

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

require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local path_source = vim.fn.stdpath('config') .. '/src/'
local source = function(path) dofile(path_source .. path) end

now(function() source('settings.lua') end)

later(function()
    add('tpope/vim-fugitive')
    require('mini.doc').setup()
end)

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

now(
    function()
        require('mini.base16').setup({
            palette = {
                base00 = '#282c34',
                base01 = '#353b45',
                base02 = '#3e4451',
                base03 = '#545862',
                base04 = '#565c64',
                base05 = '#abb2bf',
                base06 = '#b6bdca',
                base07 = '#c8ccd4',
                base08 = '#e06c75',
                base09 = '#d19a66',
                base0A = '#e5c07b',
                base0B = '#98c379',
                base0C = '#56b6c2',
                base0D = '#61afef',
                base0E = '#c678dd',
                base0F = '#be5046',
            },
        })
    end
)

now(function()
    add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_checkout = function() vim.cmd('TSUpdate') end } })

    local toggle_inc_selection_group = vim.api.nvim_create_augroup('Crnvl96ToggleIncSelection', { clear = true })

    vim.api.nvim_create_autocmd('CmdwinEnter', {
        desc = 'Disable incremental selection when entering the cmdline window',
        group = toggle_inc_selection_group,
        command = 'TSBufDisable incremental_selection',
    })

    vim.api.nvim_create_autocmd('CmdwinLeave', {
        desc = 'Enable incremental selection when leaving the cmdline window',
        group = toggle_inc_selection_group,
        command = 'TSBufEnable incremental_selection',
    })

    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            'bash',
            'c',
            'gitcommit',
            'html',
            'javascript',
            'json',
            'json5',
            'jsonc',
            'lua',
            'markdown',
            'markdown_inline',
            'query',
            'regex',
            'toml',
            'tsx',
            'typescript',
            'vim',
            'vimdoc',
            'yaml',
        },
        highlight = {
            enable = true,
            disable = function(_, buf)
                if not vim.bo[buf].modifiable then return false end
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                return ok and stats and stats.size > (250 * 1024)
            end,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<cr>',
                node_incremental = '<cr>',
                scope_incremental = false,
                node_decremental = '<bs>',
            },
        },
        indent = { enable = true },
    })
end)

now(function()
    add({
        source = 'neovim/nvim-lspconfig',
        depends = {
            {
                source = 'iguanacucumber/magazine.nvim',
                name = 'nvim-cmp',
                depends = {
                    { source = 'hrsh7th/cmp-buffer' },
                    { source = 'hrsh7th/cmp-nvim-lsp' },
                    { source = 'hrsh7th/cmp-nvim-lua' },
                    { source = 'hrsh7th/cmp-path' },
                    { source = 'hrsh7th/cmp-cmdline' },
                },
            },
            {
                source = 'williamboman/mason-lspconfig.nvim',
                depends = {
                    {
                        source = 'williamboman/mason.nvim',
                        hooks = { post_checkout = function() vim.cmd('MasonUpdate') end },
                    },
                },
            },
        },
    })

    add({
        source = 'stevearc/conform.nvim',
        depends = {
            { source = 'williamboman/mason.nvim' },
        },
    })

    local cmp = require('cmp')
    local defaults = require('cmp.config.default')()

    cmp.setup({
        preselect = cmp.PreselectMode.None,
        sorting = defaults.sorting,
        formatting = { fields = { 'kind', 'abbr', 'menu' } },
        snippet = { expand = function(args) vim.snippet.expand(args.body) end },
        performance = { max_view_entries = 10 },
        mapping = cmp.mapping.preset.insert({
            ['<C-f>'] = cmp.mapping.complete({ config = { sources = { { name = 'path' } } } }),
            ['<cr>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp', keyword_length = 2 },
            { name = 'nvim_lua', keyword_length = 2 },
        }, {
            {
                name = 'buffer',
                keyword_length = 3,
                option = {
                    get_bufnrs = function()
                        local bufs = {}

                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                            if ok and stats and stats.size < (250 * 1024) then table.insert(bufs, buf) end
                        end

                        return bufs
                    end,
                },
            },
        }),
    })

    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } },
    })

    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, {
            { name = 'cmdline' },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
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

    local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
    )

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

    local on_lsp_attach = function(client, bufnr)
        local map = function(method, lhs, rhs, desc, mode)
            local setmap = function() vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr }) end
            if client.supports_method(method) then setmap() end
        end

        local methods = vim.lsp.protocol.Methods

        local wrap = function(mod) return require('telescope.builtin')[mod](require('telescope.themes').get_ivy()) end

        map(methods.textDocument_codeAction, 'ga', vim.lsp.buf.code_action, 'List code actions')
        map(methods.textDocument_rename, 'gn', vim.lsp.buf.code_action, 'Rename symbol under cursor')
        map(methods.document_symbol, 'gs', function() wrap('lsp_document_symbols') end, 'List document symbols')
        map(methods.document_symbol, 'gS', function() wrap('lsp_workspace_symbols') end, 'List workspace symbols')
        map(methods.textDocument_definition, 'gd', function() wrap('lsp_definitions') end, 'Go to definition')
        map(methods.textDocument_references, 'gR', function() wrap('lsp_references') end, 'List references')
        -- stylua: ignore
        map(methods.textDocument_implementation, 'gi', function() wrap('lsp_implementations') end, 'List implementations')
        map(methods.textDocument_typeDefinition, 'gy', function() wrap('type_definitions') end, 'Go to type definition')
        map(methods.workspace_diagnostics, 'gx', function() wrap('diagnostics') end, 'List document diagnostics')
    end

    local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
    vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if not client then return end
        on_lsp_attach(client, vim.api.nvim_get_current_buf())
        return registerCapability(err, res, ctx)
    end

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('Crnvl96LspOnAttach', {}),
        callback = function(e)
            local client = vim.lsp.get_client_by_id(e.data.client_id)
            if not client then return end
            on_lsp_attach(client, e.buf)
        end,
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
        preset = 'modern',
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
            { source = 'mfussenegger/nvim-dap' },
            { source = 'nvim-telescope/telescope-dap.nvim' },
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
                i = { ['<f4>'] = require('telescope.actions.layout').toggle_preview },
                n = { ['<f4>'] = require('telescope.actions.layout').toggle_preview },
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
    require('telescope').load_extension('dap')

    local wrap_dap = function(mod)
        local d = require('telescope').extensions.dap
        local ivy = require('telescope.themes').get_ivy()
        return d[mod](ivy)
    end
    local wrap = function(mod) return require('telescope.builtin')[mod](require('telescope.themes').get_ivy()) end

    vim.keymap.set('n', '<leader>ff', function() wrap('find_files') end, { desc = 'Find File (CWD)' })
    vim.keymap.set('n', '<leader>fh', function() wrap('help_tags') end, { desc = 'Find Help' })
    vim.keymap.set('n', '<leader>fH', function() wrap('highlights') end, { desc = 'Find highlight groups' })
    vim.keymap.set('n', '<leader>fM', function() wrap('man_pages') end, { desc = 'Map Pages' })
    vim.keymap.set('n', '<leader>fo', function() wrap('oldfiles') end, { desc = 'Open Recent File' })
    vim.keymap.set('n', '<leader>fR', function() wrap('registers') end, { desc = 'Registers' })
    vim.keymap.set('n', '<leader>fg', function() wrap('live_grep') end, { desc = 'Live Grep' })
    vim.keymap.set('n', '<leader>fl', function() wrap('current_buffer_fuzzy_find') end, { desc = 'Grep lines' })
    vim.keymap.set('n', '<leader>fk', function() wrap('keymaps') end, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>fc', function() wrap('commands') end, { desc = 'Commands' })
    vim.keymap.set('n', '<leader>fr', function() wrap('resume') end, { desc = 'Resume last search' })
    vim.keymap.set('n', '<leader>fb', function() wrap('buffers') end, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>fdc', function() wrap_dap('commands') end, { desc = 'Dap commands' })
    vim.keymap.set('n', '<leader>fdx', function() wrap_dap('configurations') end, { desc = 'Dap configs' })
    vim.keymap.set('n', '<leader>fdl', function() wrap_dap('list_breakpoints') end, { desc = 'Dap BPs' })
    vim.keymap.set('n', '<leader>fdv', function() wrap_dap('variables') end, { desc = 'Dap Vars' })
    vim.keymap.set('n', '<leader>fdf', function() wrap_dap('frames') end, { desc = 'Dap frames' })
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

    dap.defaults.fallback.external_terminal = {
        command = vim.env.HOME .. '/.local/bin/kitty',
        args = { '-e' },
    }
    dap.defaults.fallback.force_external_terminal = true

    -- stylua: ignore
    vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = 'Breakpoint Condition' })
    vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = 'Continue' })
    --stylua: ignore
    ---@diagnostic disable-next-line: undefined-global
    vim.keymap.set('n', '<leader>da', function() dap.continue({ before = get_args }) end, { desc = 'Run with Args' })
    vim.keymap.set('n', '<leader>dC', function() dap.run_to_cursor() end, { desc = 'Run to Cursor' })
    vim.keymap.set('n', '<leader>dg', function() dap.goto_() end, { desc = 'Go to Line (No Execute)' })
    vim.keymap.set('n', '<leader>di', function() dap.step_into() end, { desc = 'Step Into' })
    vim.keymap.set('n', '<leader>dj', function() dap.down() end, { desc = 'Down' })
    vim.keymap.set('n', '<leader>dk', function() dap.up() end, { desc = 'Up' })
    vim.keymap.set('n', '<leader>dl', function() dap.run_last() end, { desc = 'Run Last' })
    vim.keymap.set('n', '<leader>do', function() dap.step_out() end, { desc = 'Step Out' })
    vim.keymap.set('n', '<leader>dO', function() dap.step_over() end, { desc = 'Step Over' })
    vim.keymap.set('n', '<leader>dp', function() dap.pause() end, { desc = 'Pause' })
    vim.keymap.set('n', '<leader>dr', function() dap.repl.toggle() end, { desc = 'Toggle REPL' })
    vim.keymap.set('n', '<leader>ds', function() dap.session() end, { desc = 'Session' })
    vim.keymap.set('n', '<leader>dt', function() dap.terminate() end, { desc = 'Terminate' })
    vim.keymap.set('n', '<leader>du', function() dapui.toggle({}) end, { desc = 'Dap UI' })
    -- stylua: ignore
    vim.keymap.set({ 'n', 'v' }, '<leader>de', function() dapui.eval(nil, { enter = true }) end, { desc = 'Eval' })
    vim.keymap.set('n', '<leader>dw', function() require('dap.ui.widgets').hover() end, { desc = 'Widgets' })

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
