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

local minideps = require('mini.deps')
minideps.setup({ path = { package = path_package } })

local add, now, later = minideps.add, minideps.now, minideps.later

now(function() require('config.opts') end)
now(function() require('config.keymaps') end)
now(function() require('config.autocmds') end)

now(function()
    add({ source = 'rose-pine/neovim', name = 'rose-pine' })

    local rose_pine = require('rose-pine')
    rose_pine.setup({
        dark_variant = 'moon',
        styles = {
            bold = true,
            italic = false,
            transparency = false,
        },
    })

    vim.cmd.colorscheme('rose-pine')
end)

now(function()
    local miniicons = require('mini.icons')
    miniicons.setup()
    miniicons.mock_nvim_web_devicons()
end)

now(function() add('nvim-lua/plenary.nvim') end)
now(function() add('nvim-neotest/nvim-nio') end)

now(function()
    add({
        source = 'williamboman/mason.nvim',
        hooks = {
            post_checkout = function() vim.cmd('MasonUpdate') end,
        },
    })

    local mason = require('mason')
    mason.setup()

    local ensure_installed = {
        'stylua',
        'prettierd',
        'js-debug-adapter',
        'debugpy',
        'black',
    }

    local mason_registry = require('mason-registry')
    mason_registry.refresh(function()
        for _, tool in ipairs(ensure_installed) do
            local pkg = mason_registry.get_package(tool)
            if not pkg:is_installed() then pkg:install() end
        end
    end)
end)

later(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        hooks = {
            post_checkout = function() vim.cmd('TSUpdate') end,
        },
    })

    local treesitter_configs = require('nvim-treesitter.configs')

    treesitter_configs.setup({
        ensure_installed = {
            'c',
            'vim',
            'vimdoc',
            'query',
            'markdown',
            'markdown_inline',
            'lua',
            'javascript',
            'typescript',
            'python',
            'ninja',
            'rst',
        },
        highlight = {
            enable = true,
            disable = function(_, buf)
                if not vim.bo[buf].modifiable then return false end
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                return ok and stats and stats.size > vim.g.bigfile_size
            end,
        },
        indent = { enable = true },
        incremental_selection = { enable = false },
    })
end)

later(function()
    add('echasnovski/mini.extra')

    local miniextra = require('mini.extra')
    miniextra.setup()
end)

later(function()
    add('echasnovski/mini.visits')

    local visits = require('mini.visits')
    visits.setup()
end)

later(function()
    add('stevearc/conform.nvim')

    local conform = require('conform')

    local function get_first_formatter(buffer, ...)
        for i = 1, select('#', ...) do
            local formatter = select(i, ...)
            if conform.get_formatter_info(formatter, buffer).available then return formatter end
        end

        return select(1, ...)
    end

    conform.setup({
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
            python = { 'black' },
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
    add('hrsh7th/cmp-nvim-lsp')
    add('hrsh7th/cmp-path')
    add('hrsh7th/cmp-buffer')
    add('hrsh7th/cmp-nvim-lua')
    add('hrsh7th/nvim-cmp')

    local cmp = require('cmp')

    cmp.setup({
        snippet = { expand = function(args) vim.snippet.expand(args.body) end },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        sorting = require('cmp.config.default')().sorting,
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
            {
                name = 'nvim_lsp',
                entry_filter = function(entry)
                    local type = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
                    return type ~= 'Text' and type ~= 'Snippet'
                end,
            },
            { name = 'nvim_lua' },
            { name = 'path' },
            { name = 'buffer' },
        }),
    })
end)

later(function()
    add('williamboman/mason-lspconfig.nvim')
    add('neovim/nvim-lspconfig')

    local function on_attach(client, bufnr)
        local set = vim.keymap.set
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        if client.supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
            set('n', 'gd', "<cmd>Pick lsp scope='definition'<CR>", { desc = 'Lsp: go to definitions', buffer = bufnr })
        end

        if client.supports_method(vim.lsp.protocol.Methods.textDocument_references) then
            local cmd = "<cmd>Pick lsp scope='references'<CR>"
            set('n', 'gr', cmd, { desc = 'Lsp: go to references', buffer = bufnr })

            vim.keymap.del({ 'n', 'v' }, 'gra')
            vim.keymap.del('n', 'grn')
            vim.keymap.del('n', 'grr')
        end

        if client.supports_method(vim.lsp.protocol.Methods.textDocument_implementation) then
            local cmd = "<cmd>Pick lsp scope='implementation'<CR>"
            set('n', 'gi', cmd, { desc = 'Lsp: go to implementations', buffer = bufnr })
        end

        if client.supports_method(vim.lsp.protocol.Methods.textDocument_typeDefinition) then
            local cmd = "<cmd>Pick lsp scope='type_definition'<CR>"
            set('n', 'gy', cmd, { desc = 'Lsp: go to type definition', buffer = bufnr })
        end

        if client.supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
            set('n', 'ga', function() vim.lsp.buf.code_action() end, { desc = 'Lsp: code actions', buffer = bufnr })
        end

        if client.supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
            local cmd = function() vim.lsp.buf.rename() end
            set('n', 'gn', cmd, { desc = 'Lsp: rename symbol under cursor', buffer = bufnr })
        end

        if client.supports_method(vim.lsp.protocol.Methods.workspace_diagnostic) then
            set('n', '<leader>fd', '<cmd>Pick diagnostic<CR>', { desc = 'Lsp: Pick diagnostics', buffer = bufnr })
        end

        if client.supports_method(vim.lsp.protocol.Methods.document_symbol) then
            local cmd = "<cmd>Pick lsp scope='document_symbol'<CR>"
            set('n', '<leader>fs', cmd, { desc = 'Lsp: Pick document symbols', buffer = bufnr })
        end

        if client.supports_method(vim.lsp.protocol.Methods.workspace_symbol) then
            local cmd = "<cmd>Pick lsp scope='workspace_symbol'<CR>"
            set('n', '<leader>fS', cmd, { desc = 'Lsp: Pick workspace symbols', buffer = bufnr })
        end

        if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            local cmd = function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end

            vim.keymap.set('n', '<leader>ci', cmd, { desc = 'Lsp: toggle inlay hints', buffer = bufnr })
        end
    end

    local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
    vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if not client then return end
        on_attach(client, vim.api.nvim_get_current_buf())
        return registerCapability(err, res, ctx)
    end

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(e)
            local client = vim.lsp.get_client_by_id(e.data.client_id)
            if not client then return end
            on_attach(client, e.buf)
        end,
    })

    local servers = {
        eslint = { settings = { format = false } },
        basedpyright = {},
        ruff = {
            cmd_env = { RUFF_TRACE = 'messages' },
            init_options = {
                settings = {
                    logLevel = 'error',
                },
            },
        },
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
            on_init = function(client)
                local path = client.workspace_folders
                    and client.workspace_folders[1]
                    and client.workspace_folders[1].name
                if
                    not path
                    or not (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                    client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                        Lua = {
                            runtime = {
                                version = 'LuaJIT',
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME,
                                    '${3rd}/luv/library',
                                },
                            },
                        },
                    })
                    client.notify(
                        vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
                        { settings = client.config.settings }
                    )
                end

                return true
            end,
            settings = {
                Lua = {
                    format = { enable = false },
                    hint = {
                        enable = true,
                        arrayIndex = 'Disable',
                    },
                    completion = { callSnippet = 'Replace' },
                },
            },
        },
    }

    local capabilities = function()
        return vim.tbl_deep_extend(
            'force',
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require('cmp_nvim_lsp').default_capabilities()
        )
    end

    local mason_lspconfig = require('mason-lspconfig')
    local lspconfig = require('lspconfig')

    mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
            function(server_name)
                local server = servers[server_name] or {}
                server.capabilities = capabilities()
                lspconfig[server_name].setup(server)
            end,
        },
    })
end)

later(function()
    local minifiles = require('mini.files')

    minifiles.setup({
        mappings = {
            close = 'q',
            go_in = '',
            go_in_plus = '<CR>',
            go_out = '',
            go_out_plus = '-',
            mark_goto = "'",
            mark_set = 'm',
            reset = '<BS>',
            reveal_cwd = '@',
            show_help = 'g?',
            synchronize = '=',
            trim_left = '<',
            trim_right = '>',
        },
        options = {
            permanent_delete = false,
        },
        windows = {
            preview = true,
            width_preview = 120,
        },
    })

    vim.api.nvim_create_autocmd('User', {
        group = vim.api.nvim_create_augroup(vim.g.whoami .. '/mini_files_setup', { clear = true }),
        pattern = 'MiniFilesWindowOpen',
        callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'rounded' }) end,
    })

    vim.keymap.set(
        'n',
        '-',
        '<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>',
        { desc = 'Explorer (Mini.files)' }
    )
end)

later(function()
    local minipick = require('mini.pick')
    minipick.setup({
        options = {
            use_cache = true,
        },
        window = {
            prompt_cursor = '_',
            prompt_prefix = '',
            config = {
                border = 'rounded',
                height = math.floor(0.618 * vim.o.lines),
                width = math.floor(0.850 * vim.o.columns),
            },
        },
    })

    vim.ui.select = minipick.ui_select

    vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<CR>', { desc = 'Pick files' })
    vim.keymap.set('n', '<leader>fk', '<cmd>Pick keymaps<CR>', { desc = 'Pick keymaps' })
    vim.keymap.set('n', '<leader>fl', '<cmd>Pick buf_lines<CR>', { desc = 'Pick buflines' })
    vim.keymap.set('n', '<leader>fv', '<cmd>Pick visit_paths<CR>', { desc = 'Pick visit paths' })
    vim.keymap.set('n', '<leader>fm', '<cmd>Pick visit_labels<CR>', { desc = 'Pick labels' })
    vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<CR>', { desc = 'Pick grep' })
    vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<CR>', { desc = 'Pick help' })
    vim.keymap.set('n', '<leader>fr', '<cmd>Pick resume<CR>', { desc = 'Pick resume' })
    vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<CR>', { desc = 'Pick buffers' })
end)

later(function()
    add('sindrets/diffview.nvim')

    local diffview = require('diffview')
    diffview.setup()
end)

later(function()
    add('NeogitOrg/neogit')

    local neogit = require('neogit')

    neogit.setup({
        disable_signs = true,
        graph_style = 'unicode',
        disable_line_numbers = false,
        kind = 'replace',
    })

    vim.keymap.set('n', '<Leader>gg', '<cmd>Neogit<CR>', { desc = 'Neogit' })
end)

later(function()
    add('mfussenegger/nvim-dap-python')
    add('jbyuki/one-small-step-for-vimkind')
    add('rcarriga/nvim-dap-ui')
    add('mfussenegger/nvim-dap')

    for name, sign in pairs({
        Stopped = { ' ', 'DiagnosticWarn', 'DapStoppedLine' },
        Breakpoint = { ' ', 'DiagnosticInfo', nil, nil },
        BreakpointCondition = { ' ', 'DiagnosticInfo', nil, nil },
        BreakpointRejected = { ' ', 'DiagnosticError', nil, nil },
        LogPoint = { ' ', 'DiagnosticInfo', nil, nil },
    }) do
        vim.fn.sign_define('Dap' .. name, { text = sign[1], texthl = sign[2], linehl = sign[3], numhl = sign[3] })
    end

    local dap = require('dap')
    local dapui = require('dapui')
    dapui.setup({ floating = { border = 'rounded' } })
    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

    -- setup dap config by VsCode launch.json file
    local vscode = require('dap.ext.vscode')
    local json = require('plenary.json')
    vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end

    -- Extends dap.configurations with entries read from .vscode/launch.json
    if vim.fn.filereadable('.vscode/launch.json') then vscode.load_launchjs() end

    -- Setup DAP for Python debugging
    local dap_py = require('dap-python')
    dap_py.setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')

    -- Setup DAP for Lua debugging
    dap.adapters.nlua = function(callback, conf)
        local adapter = { type = 'server', host = conf.host or '127.0.0.1', port = conf.port or 8086 }
        if conf.start_neovim then
            local dap_run = dap.run
            dap.run = function(c)
                adapter.port = c.port
                adapter.host = c.host
            end
            require('osv').run_this()
            dap.run = dap_run
        end
        callback(adapter)
    end

    dap.configurations.lua = {
        { type = 'nlua', request = 'attach', name = 'Run this file', start_neovim = {} },
        {
            type = 'nlua',
            request = 'attach',
            name = 'Attach to running Neovim instance (port = 8086)',
            port = 8086,
        },
    }

    -- Setup DAP for Javascript debugging
    local javascript_filetypes =
        { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'javascript.jsx', 'typescript.tsx' }

    for _, adapter in ipairs({ 'node', 'pwa-node' }) do
        require('dap.ext.vscode').type_to_filetypes[adapter] = javascript_filetypes
    end

    for _, filetype in ipairs(javascript_filetypes) do
        if not dap.configurations[filetype] then
            dap.configurations[filetype] = {
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Launch file (custom)',
                    program = '${file}',
                    cwd = '${workspaceFolder}',
                },
                {
                    type = 'pwa-node',
                    request = 'attach',
                    name = 'Attach (custom)',
                    processId = require('dap.utils').pick_process,
                    cwd = vim.fn.getcwd(),
                    sourceMaps = true,
                    resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
                    skipFiles = { '${workspaceFolder}/node_modules/**/*.js' },
                },
            }
        end
    end

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

    vim.api.nvim_create_autocmd('FileType', {
        desc = 'Setup lua debug specific keymaps',
        group = vim.api.nvim_create_augroup(vim.g.whoami .. '/crnvl96_dap_group', { clear = true }),
        pattern = { 'lua' },
        callback = function(e)
            vim.keymap.set(
                'n',
                '<Leader>dl',
                function() require('osv').launch({ port = 8086 }) end,
                { desc = 'Launch nlua (8086)', buffer = true }
            )
        end,
    })

    vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Set breakpoint' })
    vim.keymap.set('n', '<Leader>dc', function() require('dap').continue() end, { desc = 'Dap continue' })
    vim.keymap.set('n', '<Leader>dt', function() require('dap').terminate() end, { desc = 'Dap terminate session' })
    vim.keymap.set('n', '<Leader>du', function() require('dapui').toggle() end, { desc = 'Dap UI' })
    vim.keymap.set(
        'n',
        '<Leader>de',
        function() require('dapui').eval(nil, { enter = true }) end,
        { desc = 'Dap Eval' }
    )
end)
