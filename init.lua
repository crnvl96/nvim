pcall(function() vim.loader.enable() end)

-- Define main config table
_G.Config = {
    path_package = vim.fn.stdpath('data') .. '/site/',
    path_source = vim.fn.stdpath('config') .. '/src/',
}

local mini_path = Config.path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd([[echo "Installing 'mini.nvim'" | redraw]])
    local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
    vim.fn.system(clone_cmd)
end
require('mini.deps').setup({ path = { package = Config.path_package } })

local add, now, ltr = MiniDeps.add, MiniDeps.now, MiniDeps.later
local source = function(path) dofile(Config.path_source .. path) end

now(function() source('opts.lua') end)
now(function() source('keymaps.lua') end)
now(function() source('dependencies.lua') end)

now(function() require('mini.statusline').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.extra').setup() end)

ltr(function() require('mini.bracketed').setup() end)
ltr(function() require('mini.trailspace').setup() end)
ltr(function() require('mini.visits').setup() end)
ltr(function() require('mini.diff').setup() end)
ltr(function() require('mini.git').setup() end)
ltr(function() require('mini.indentscope').setup() end)
ltr(function() require('mini.bufremove').setup() end)
ltr(function() require('mini.doc').setup() end)
ltr(function() require('mini.test').setup() end)

now(function() source('mini/misc.lua') end)
now(function() source('mini/hues.lua') end)
now(function() source('mini/icons.lua') end)
now(function() source('mini/notify.lua') end)

ltr(function() source('mini/clue.lua') end)
ltr(function() source('mini/completion.lua') end)

ltr(function() source('mason.lua') end)
ltr(function() source('lsp.lua') end)
ltr(function() source('minifiles.lua') end)
ltr(function() source('treesitter.lua') end)
ltr(function() source('operators.lua') end)
ltr(function() source('jump.lua') end)

ltr(function()
    local hi_words = require('mini.extra').gen_highlighter.words

    require('mini.hipatterns').setup({
        highlighters = {
            fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
            hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
            todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
            note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

            hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
    })
end)

ltr(function()
    require('mini.pick').setup({
        options = {
            use_cache = true,
        },
        window = {
            prompt_cursor = '_',
            prompt_prefix = '',
        },
    })

    vim.ui.select = require('mini.pick').ui_select
end)

ltr(function()
    add('stevearc/conform.nvim')

    local function get_first_formatter(buffer, ...)
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

ltr(function()
    add('mfussenegger/nvim-dap-python')
    add('jbyuki/one-small-step-for-vimkind')
    add('rcarriga/nvim-dap-ui')
    add('mfussenegger/nvim-dap')

    local icons = {
        Stopped = { ' ', 'DiagnosticWarn', 'DapStoppedLine' },
        Breakpoint = { ' ', 'DiagnosticInfo', nil, nil },
        BreakpointCondition = { ' ', 'DiagnosticInfo', nil, nil },
        BreakpointRejected = { ' ', 'DiagnosticError', nil, nil },
        LogPoint = { ' ', 'DiagnosticInfo', nil, nil },
    }

    for name, sign in pairs(icons) do
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
        callback = function()
            vim.keymap.set(
                'n',
                '<Leader>dl',
                function() require('osv').launch({ port = 8086 }) end,
                { desc = 'Launch nlua (8086)', buffer = true }
            )
        end,
    })
end)

ltr(function()
    add('danymat/neogen')
    require('neogen').setup({
        languages = {
            lua = { template = { annotation_convention = 'emmylua' } },
            python = { template = { annotation_convention = 'numpydoc' } },
        },
    })
end)

ltr(function()
    add({
        source = 'crnvl96/lazydocker.nvim',
        checkout = 'v2.0.0',
    })

    require('lazydocker').setup()
end)
