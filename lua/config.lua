local M = {
    path = {
        package = vim.fn.stdpath('data') .. '/site/',
    },
    lsp = {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        setup_dynamic_capabilities = function(callback)
            local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
            vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                if not client then return end
                callback(client, vim.api.nvim_get_current_buf())
                return registerCapability(err, res, ctx)
            end
        end,
        on_attach = function(client, bufnr)
            local m = vim.lsp.protocol.Methods
            local map = function(method, lhs, rhs, desc, mode)
                local sup = client.supports_method(method)
                local setmap = function() vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr }) end

                if sup then setmap() end
            end

            vim.o.omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

            map(m.textDocument_definition, 'gd', "<cmd>Pick lsp scope='definition'<CR>", 'Go to definition')
            map(m.textDocument_references, 'gR', "<cmd>Pick lsp scope='references'<CR>", 'List references')
            map(m.textDocument_implementation, 'gi', "<cmd>Pick lsp scope='implementation'<CR>", 'List implementations')
            map(
                m.textDocument_typeDefinition,
                'gy',
                "<cmd>Pick lsp scope='type_definition'<CR>",
                'Go to type definition'
            )
            map(m.textDocument_codeAction, 'ga', vim.lsp.buf.code_action, 'List code actions')
            map(m.textDocument_rename, 'gn', vim.lsp.buf.rename, 'Rename symbol under cursor')
            map(m.workspace_diagnostics, '<Leader>fd', '<cmd>Pick diagnostic<CR>', 'List workspace diagnostics')
            map(m.document_symbol, '<Leader>fs', "<cmd>Pick lsp scope='document_symbol'<CR>", 'List document symbols')
            map(
                m.workspace_symbol,
                '<Leader>fS',
                "<cmd>Pick lsp scope='workspace_symbol'<CR>",
                'List workspace symbols'
            )

            map(
                m.textDocument_inlayHint,
                '<Leader>ci',
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
                end,
                'Toggle inlay hints'
            )
        end,
        servers = {
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
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                            -- Setup your lua path
                            path = vim.split(package.path, ';'),
                        },
                        diagnostics = {
                            -- Get the language server to recognize common globals
                            globals = { 'vim', 'describe', 'it', 'before_each', 'after_each' },
                            disable = { 'need-check-nil' },
                            -- Don't make workspace diagnostic, as it consumes too much CPU and RAM
                            workspaceDelay = -1,
                        },
                        workspace = {
                            -- Don't analyze code from submodules
                            ignoreSubmodules = true,
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            },
        },
    },
    plugins = {
        mason = {
            tools = {
                'stylua',
                'prettierd',
                'js-debug-adapter',
                'debugpy',
                'black',
            },
        },
        conform = {
            get_first_formatter = function(buffer, ...)
                for i = 1, select('#', ...) do
                    local formatter = select(i, ...)
                    if require('conform').get_formatter_info(formatter, buffer).available then return formatter end
                end

                return select(1, ...)
            end,
        },
        treesitter = {
            parsers = {
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
        },
        dap = {
            bootstrap = function()
                local icons = {
                    Stopped = { ' ', 'DiagnosticWarn', 'DapStoppedLine' },
                    Breakpoint = { ' ', 'DiagnosticInfo', nil, nil },
                    BreakpointCondition = { ' ', 'DiagnosticInfo', nil, nil },
                    BreakpointRejected = { ' ', 'DiagnosticError', nil, nil },
                    LogPoint = { ' ', 'DiagnosticInfo', nil, nil },
                }

                for name, sign in pairs(icons) do
                    vim.fn.sign_define(
                        'Dap' .. name,
                        { text = sign[1], texthl = sign[2], linehl = sign[3], numhl = sign[3] }
                    )
                end

                require('dapui').setup({ floating = { border = 'rounded' } })
                require('dap').listeners.after.event_initialized['dapui_config'] = function() require('dapui').open() end
                require('dap').listeners.before.event_terminated['dapui_config'] = function() require('dapui').close() end
                require('dap').listeners.before.event_exited['dapui_config'] = function() require('dapui').close() end

                require('dap.ext.vscode').json_decode = function(str)
                    return vim.json.decode(require('plenary.json').json_strip_comments(str))
                end

                if vim.fn.filereadable('.vscode/launch.json') then require('dap.ext.vscode').load_launchjs() end
            end,
            setup = {
                lua = function()
                    require('dap').adapters.nlua = function(callback, conf)
                        local adapter = { type = 'server', host = conf.host or '127.0.0.1', port = conf.port or 8086 }
                        if conf.start_neovim then
                            local dap_run = require('dap').run
                            require('dap').run = function(c)
                                adapter.port = c.port
                                adapter.host = c.host
                            end
                            require('osv').run_this()
                            require('dap').run = dap_run
                        end
                        callback(adapter)
                    end

                    require('dap').configurations.lua = {
                        { type = 'nlua', request = 'attach', name = 'Run this file', start_neovim = {} },
                        {
                            type = 'nlua',
                            request = 'attach',
                            name = 'Attach to running Neovim instance (port = 8086)',
                            port = 8086,
                        },
                    }

                    vim.api.nvim_create_autocmd('FileType', {
                        desc = 'Setup lua debug specific keymaps',
                        group = vim.api.nvim_create_augroup('crnvl96_dap_group', { clear = true }),
                        pattern = { 'lua' },
                        callback = function()
                            vim.keymap.set(
                                'n',
                                '<Leader>dl',
                                function() require('osv').launch({ port = 8086 }) end,
                                { desc = 'Launch nlua (8086)', buffer = true }
                            )
                        end,
                    })
                end,
                python = function()
                    local dap_py = require('dap-python')
                    dap_py.setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')
                end,
                javascript = function()
                    local javascript_filetypes = {
                        'typescript',
                        'javascript',
                        'typescriptreact',
                        'javascriptreact',
                        'javascript.jsx',
                        'typescript.tsx',
                    }

                    for _, adapter in ipairs({ 'node', 'pwa-node' }) do
                        require('dap.ext.vscode').type_to_filetypes[adapter] = javascript_filetypes
                    end

                    for _, filetype in ipairs(javascript_filetypes) do
                        if not require('dap').configurations[filetype] then
                            require('dap').configurations[filetype] = {
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

                    if not require('dap').adapters['pwa-node'] then
                        require('dap').adapters['pwa-node'] = {
                            type = 'server',
                            host = 'localhost',
                            port = '${port}',
                            executable = {
                                command = 'node',
                                args = {
                                    vim.fn.stdpath('data')
                                        .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
                                    '${port}',
                                },
                            },
                        }
                    end

                    if not require('dap').adapters['node'] then
                        require('dap').adapters['node'] = function(cb, config)
                            if config.type == 'node' then config.type = 'pwa-node' end
                            local nativeAdapter = require('dap').adapters['pwa-node']
                            if type(nativeAdapter) == 'function' then
                                nativeAdapter(cb, config)
                            else
                                cb(nativeAdapter)
                            end
                        end
                    end
                end,
            },
        },
    },
    delete_other_buffers = function()
        local current = vim.api.nvim_get_current_buf()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if current ~= buf then require('mini.bufremove').wipeout(buf, true) end
        end

        vim.cmd('redraw!')
    end,
}

return M
