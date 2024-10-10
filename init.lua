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
    vim.o.guicursor = ''
    vim.o.splitkeep = 'screen'
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.timeoutlen = 200
    vim.o.swapfile = false
    vim.o.shiftwidth = 2
    vim.o.scrolloff = 8
    vim.o.pumblend = 0
    vim.o.winblend = 0
    vim.o.list = false
    vim.o.background = 'dark'
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end
    vim.cmd('packadd cfilter')
end)

now(
    function()
        require('mini.basics').setup({
            options = {
                extra_ui = true,
                win_borders = 'double',
            },
        })
    end
)

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

    icons.mock_nvim_web_devicons()
    icons.tweak_lsp_kind()
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

now(function() add('nvim-neotest/nvim-nio') end)

now(function() add('nvim-lua/plenary.nvim') end)

now(function() require('mini.extra').setup() end)

now(function() require('mini.visits').setup() end)

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

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(e)
            local client = vim.lsp.get_client_by_id(e.data.client_id)
            if not client then return end
            Config.lsp.on_attach(client, e.buf)
        end,
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
        formatters_by_ft = {
            markdown = function(buf)
                return { Config.plugins.conform.get_first_formatter(buf, 'prettierd', 'prettier'), 'injected' }
            end,
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

later(function()
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

    vim.api.nvim_create_autocmd('User', {
        group = vim.api.nvim_create_augroup('crnvl96_mini_files', {}),
        pattern = 'MiniFilesWindowOpen',
        callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'double' }) end,
    })
end)

later(function()
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

later(
    function()
        require('mini.clue').setup({
            clues = {
                require('mini.clue').gen_clues.builtin_completion(),
                require('mini.clue').gen_clues.g(),
                require('mini.clue').gen_clues.marks(),
                require('mini.clue').gen_clues.registers(),
                require('mini.clue').gen_clues.windows({ submode_resize = true }),
                require('mini.clue').gen_clues.z(),
                { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
                { mode = 'n', keys = '<Leader>c', desc = '+Code' },
                { mode = 'n', keys = '<Leader>d', desc = '+DAP' },
                { mode = 'n', keys = '<Leader>f', desc = '+Files' },
                { mode = 'n', keys = '<Leader>g', desc = '+Git' },
                { mode = 'n', keys = '<Leader>o', desc = '+Operators' },
            },
            triggers = {
                { mode = 'n', keys = '<Leader>' },
                { mode = 'x', keys = '<Leader>' },
                { mode = 'n', keys = [[\]] },
                { mode = 'n', keys = '[' },
                { mode = 'n', keys = ']' },
                { mode = 'x', keys = '[' },
                { mode = 'x', keys = ']' },
                { mode = 'i', keys = '<C-x>' },
                { mode = 'n', keys = 'g' },
                { mode = 'x', keys = 'g' },
                { mode = 'n', keys = "'" },
                { mode = 'n', keys = '`' },
                { mode = 'x', keys = "'" },
                { mode = 'x', keys = '`' },
                { mode = 'n', keys = '"' },
                { mode = 'x', keys = '"' },
                { mode = 'i', keys = '<C-r>' },
                { mode = 'c', keys = '<C-r>' },
                { mode = 'n', keys = '<C-w>' },
                { mode = 'n', keys = 'z' },
                { mode = 'x', keys = 'z' },
            },
            window = { config = { width = 'auto', border = 'double' }, delay = 200 },
        })
    end
)

later(function()
    add('mfussenegger/nvim-dap-python')
    add('jbyuki/one-small-step-for-vimkind')
    add('rcarriga/nvim-dap-ui')
    add('mfussenegger/nvim-dap')

    Config.plugins.dap.bootstrap()
    Config.plugins.dap.setup.lua()
    Config.plugins.dap.setup.python()
    Config.plugins.dap.setup.javascript()
end)

later(function() require('mini.test').setup() end)

later(function() require('mini.doc').setup() end)

later(function()
    add('danymat/neogen')

    require('neogen').setup({
        languages = {
            lua = { template = { annotation_convention = 'emmylua' } },
            python = { template = { annotation_convention = 'numpydoc' } },
        },
    })
end)

later(function()
    local set = vim.keymap.set

    set('x', 'p', 'P')
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

-- Development plugins
MiniDeps.later(function()
    MiniDeps.add({
        source = 'crnvl96/lazydocker.nvim',
        checkout = 'v2.0.0',
    })

    require('lazydocker').setup()
end)
