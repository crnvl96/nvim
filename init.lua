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

local deps = require('mini.deps')
deps.setup({ path = { package = path_package } })

local add, now, ltr = deps.add, deps.now, deps.later

local tools = {
    servers = {
        vtsls = {},
        lua_ls = {
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                            '${3rd}/luv/library',
                            '${3rd}/busted/library',
                        },
                    },
                },
            },
        },
        eslint = {
            settings = {
                format = false,
            },
        },
        gopls = {
            settings = {
                gopls = {
                    gofumpt = true,
                },
            },
        },
    },
    ts_parsers = {
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
    },
    formatters = {
        'stylua',
        'prettierd',
        'staticcheck',
        'gofumpt',
        'goimports',
        'golines',
    },
}

now(function()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ','
    vim.g.whoami = 'crnvl96'

    vim.o.splitbelow = true
    vim.o.splitright = true
    vim.o.cursorline = true
    vim.o.showcmd = false
    vim.o.showmode = false
    vim.o.ruler = false
    vim.o.laststatus = 0
    vim.o.foldcolumn = '0'
    vim.o.foldenable = true
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
    vim.o.smartcase = true
    vim.o.ignorecase = true
    vim.o.infercase = true
    vim.o.mouse = 'a'
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.clipboard = 'unnamedplus'
    vim.o.signcolumn = 'yes'
    vim.o.fillchars = 'eob: '
    vim.o.termguicolors = true
    vim.o.undofile = true
    vim.o.updatetime = 300
    vim.o.timeoutlen = 200
    vim.o.backup = false
    vim.o.writebackup = false
    vim.o.wrap = false
    vim.o.wildignorecase = true
    vim.o.background = 'dark'

    vim.opt.formatoptions:append('l1')
    vim.opt.shortmess:append('WcC')
    vim.opt.diffopt:append('linematch:60')
    vim.opt.wildoptions:append('fuzzy')
    vim.opt.path:append('**')
    vim.opt.wildignore:append('*/node_modules/*,*/dist/*')
    vim.opt.completeopt:append('menuone,noinsert,noselect,popup,fuzzy')

    if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end
    if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

    vim.cmd('filetype plugin indent on')
    vim.cmd('packadd cfilter')
end)

now(function()
    vim.keymap.set({ 'n', 'x', 'i' }, '<c-s>', '<esc><cmd>w<cr><esc>')
    vim.keymap.set({ 'n', 'x', 'i' }, '<esc>', '<esc><cmd>noh<cr><esc>')

    vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
    vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

    vim.keymap.set('x', 'p', 'P')

    vim.keymap.set('n', 'Y', 'v$<left>y')
    vim.keymap.set('n', '<c-d>', '<c-d>zz')
    vim.keymap.set('n', '<c-u>', '<c-u>zz')
    vim.keymap.set('n', 'n', 'nzzzv')
    vim.keymap.set('n', 'N', 'Nzzzv')
    vim.keymap.set('n', '*', '*zzzv')
    vim.keymap.set('n', '#', '#zzzv')

    vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')
    vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>')
    vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>')
    vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>')
    vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>')
    vim.keymap.set('t', '<C-/>', '<cmd>close<cr>')
    vim.keymap.set('t', '<c-_>', '<cmd>close<cr>')

    vim.keymap.set('x', '<', '<gv')
    vim.keymap.set('x', '>', '>gv')
    vim.keymap.set('n', '<', '<cmd>bn<cr>')
    vim.keymap.set('n', '>', '<cmd>bp<cr>')

    vim.keymap.set('n', '<c-h>', '<c-w>h')
    vim.keymap.set('n', '<c-j>', '<c-w>j')
    vim.keymap.set('n', '<c-k>', '<c-w>k')
    vim.keymap.set('n', '<c-l>', '<c-w>l')
    vim.keymap.set('n', '<c-up>', '<cmd>resize +5<cr>')
    vim.keymap.set('n', '<c-down>', '<cmd>resize -5<cr>')
    vim.keymap.set('n', '<c-left>', '<cmd>vertical resize -20<cr>')
    vim.keymap.set('n', '<c-right>', '<cmd>vertical resize +20<cr>')
    vim.keymap.set('n', '<c-w>+', '<cmd>resize +5<cr>')
    vim.keymap.set('n', '<c-w>-', '<cmd>resize -5<cr>')
    vim.keymap.set('n', '<c-w><', '<cmd>vertical resize -20<cr>')
    vim.keymap.set('n', '<c-w>>', '<cmd>vertical resize +20<cr>')
    vim.keymap.set('n', '-', '<cmd>Ex<cr>')

    vim.keymap.set('n', ']t', '<cmd>tabnext<cr>', { desc = 'next tab' })
    vim.keymap.set('n', '[t', '<cmd>tabprevious<cr>', { desc = 'previous tab' })
    vim.keymap.set('n', '[T', '<cmd>tabfirst<cr>', { desc = 'first tab' })
    vim.keymap.set('n', ']T', '<cmd>tablast<cr>', { desc = 'last tab' })

    vim.keymap.set('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'close other tabs' })
    vim.keymap.set('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'new tab' })
    vim.keymap.set('n', '<leader><tab>c', '<cmd>tabclose<cr>', { desc = 'close tab' })
end)

now(function()
    vim.api.nvim_create_autocmd('TextYankPost', {
        pattern = '*',
        group = vim.api.nvim_create_augroup(vim.g.whoami .. '/highlight_on_yank', {}),
        callback = function() vim.highlight.on_yank() end,
    })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        group = vim.api.nvim_create_augroup(vim.g.whoami .. '/setup_format_opts', {}),
        callback = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
    })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'qf', 'gitsigns-blame', 'fugitive', 'fugitiveblame', 'grug-far' },
        group = vim.api.nvim_create_augroup(vim.g.whoami .. '/close_with_q', {}),
        callback = function() vim.keymap.set('n', 'q', '<cmd>close<cr>', { desc = 'close with <esc>', buffer = true }) end,
    })

    vim.api.nvim_create_autocmd('VimResized', {
        pattern = '*',
        group = vim.api.nvim_create_augroup(vim.g.whoami .. '/auto_resize_vim', {}),
        callback = function()
            vim.cmd('tabdo wincmd =')
            vim.cmd('tabnext ' .. vim.fn.tabpagenr())
        end,
    })

    vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        group = vim.api.nvim_create_augroup(vim.g.whoami .. '/colorscheme_fix', {}),
        callback = function()
            vim.api.nvim_set_hl(0, 'Flovim.api.nvim_set_hlatBorder', { link = 'Normal' })
            vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'Normal' })
            vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })

            vim.cmd('highlight Winbar guibg=none')
        end,
    })

    -- go
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup(vim.g.whoami .. '/go_opts', {}),
        pattern = { 'go' },
        callback = function() vim.cmd('setlocal shiftwidth=4 tabstop=4') end,
    })
end)

now(function()
    local base16 = require('mini.base16')
    base16.setup({
        palette = {
            base00 = '#2E3440',
            base01 = '#3B4252',
            base02 = '#434C5E',
            base03 = '#4C566A',
            base04 = '#D8DEE9',
            base05 = '#E5E9F0',
            base06 = '#ECEFF4',
            base07 = '#8FBCBB',
            base08 = '#88C0D0',
            base09 = '#81A1C1',
            base0A = '#5E81AC',
            base0B = '#BF616A',
            base0C = '#D08770',
            base0D = '#EBCB8B',
            base0E = '#A3BE8C',
            base0F = '#B48EAD',
        },
    })
end)

ltr(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        hooks = { post_update = function() vim.cmd('TSUpdate') end },
    })

    require('nvim-treesitter.configs').setup({
        ensure_installed = tools.ts_parsers,
        sync_install = false,
        auto_install = true,
        indent = { enable = true },
        highlight = {
            enable = false,
            disable = true,
            additional_vim_regex_highlighting = { 'markdown' },
        },
    })
end)

ltr(function()
    add({ source = 'nvim-treesitter/nvim-treesitter-textobjects' })

    local miniai = require('mini.ai')

    miniai.setup({
        n_lines = 300,
        custom_textobjects = {
            f = miniai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
        },
        silent = true,
        search_method = 'cover',
        mappings = {
            around_next = '',
            inside_next = '',
            around_last = '',
            inside_last = '',
        },
    })
end)

ltr(function()
    add({ source = 'MagicDuck/grug-far.nvim' })

    require('grug-far').setup({ headerMaxWidth = 80 })
end)

ltr(function()
    add('stevearc/oil.nvim')

    local oil = require('oil')

    oil.setup({
        columns = { 'icon' },
        watch_for_changes = true,
        view_options = { show_hidden = true },
        keymaps = {
            ['<C-s>'] = false,
            ['<C-h>'] = false,
            ['<C-l>'] = false,
            ['<M-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
            ['<M-s>'] = {
                'actions.select',
                opts = { horizontal = true },
                desc = 'Open the entry in a horizontal split',
            },
        },
    })
end)

ltr(function()
    add({ source = 'ibhagwan/fzf-lua' })

    local fzf = require('fzf-lua')

    fzf.setup({
        fzf_colors = {
            bg = { 'bg', 'Normal' },
            gutter = { 'bg', 'Normal' },
            info = { 'fg', 'Conditional' },
            scrollbar = { 'bg', 'Normal' },
            separator = { 'fg', 'Comment' },
        },
        fzf_opts = {
            ['--info'] = 'default',
            ['--layout'] = 'reverse-list',
            ['--cycle'] = '',
        },
        winopts = {
            height = 0.85,
            width = 0.80,
            row = 0.50,
            col = 0.50,
            border = 'none',
            backdrop = 60,
            preview = {
                hidden = 'hidden',
                vertical = 'up:55%',
                horizontal = 'right:60%',
                layout = 'flex',
                flip_columns = 150,
            },
        },
        keymap = {
            fzf = {
                true,
                ['alt-u'] = 'unix-line-discard',
                ['ctrl-d'] = 'half-page-down',
                ['ctrl-u'] = 'half-page-up',
                ['ctrl-f'] = 'preview-page-down',
                ['ctrl-b'] = 'preview-page-up',
            },
            builtin = {
                true,
                ['<C-f>'] = 'preview-page-down',
                ['<C-b>'] = 'preview-page-up',
            },
        },
    })

    vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Files' })
    vim.keymap.set('n', '<leader>fo', fzf.oldfiles, { desc = 'Oldfiles' })
    vim.keymap.set('n', '<leader>fq', fzf.quickfix, { desc = 'Qf' })
    vim.keymap.set('n', '<leader>fl', fzf.blines, { desc = 'Lines' })
    vim.keymap.set('n', '<leader>ft', fzf.tabs, { desc = 'Tabs' })
    vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Lgrep' })
    vim.keymap.set('x', '<leader>fg', fzf.grep_visual, { desc = 'Lgrep visual' })
    vim.keymap.set('n', '<leader>fG', fzf.live_grep_resume, { desc = 'Lgrep resume' })
    vim.keymap.set('n', '<leader>fr', '<cmd>GrugFar<cr>', { desc = 'replace' })
    vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'oil' })

    fzf.register_ui_select()
end)

ltr(function()
    add({ source = 'stevearc/conform.nvim' })

    local conform = require('conform')

    local function first(buf, ...)
        for i = 1, select('#', ...) do
            local formatter = select(i, ...)
            if conform.get_formatter_info(formatter, buf).available then return formatter end
        end

        return select(1, ...)
    end

    conform.setup({
        notify_on_error = false,
        formatters_by_ft = {
            lua = { 'stylua' },
            javascript = { 'prettierd', 'prettier', stop_after_first = true },
            typescript = { 'prettierd', 'prettier', stop_after_first = true },
            javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
            typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
            ['javascript.jsx'] = { 'prettierd', 'prettier', stop_after_first = true },
            ['typescript.tsx'] = { 'prettierd', 'prettier', stop_after_first = true },
            json = { 'prettierd', 'prettier', stop_after_first = true },
            jsonc = { 'prettierd', 'prettier', stop_after_first = true },
            json5 = { 'prettierd', 'prettier', stop_after_first = true },
            go = { 'gofumpt', 'goimports', 'golines' },
            markdown = function(buf) return { first(buf, 'prettierd', 'prettier'), 'injected' } end,
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
    add({ source = 'hrsh7th/cmp-buffer' })
    add({ source = 'hrsh7th/cmp-path' })
    add({ source = 'hrsh7th/cmp-nvim-lua' })
    add({ source = 'hrsh7th/cmp-nvim-lsp' })
    add({ source = 'hrsh7th/nvim-cmp' })

    local cmp = require('cmp')
    local cmp_defaults = require('cmp.config.default')()
    local cmp_types = require('cmp.types')

    cmp.setup({
        snippet = {
            expand = function(args) vim.snippet.expand(args.body) end,
        },
        sorting = cmp_defaults.sorting,
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping({
                i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    else
                        fallback()
                    end
                end,
            }),
        }),
        sources = cmp.config.sources({
            {
                name = 'nvim_lsp',
                entry_filter = function(entry)
                    local kind = entry:get_kind()
                    local type = cmp_types.lsp.CompletionItemKind[kind]
                    return type ~= 'Text' and type ~= 'Snippet'
                end,
            },
            { name = 'nvim_lua' },
            { name = 'path' },
        }, {
            { name = 'buffer' },
        }),
    })
end)

ltr(function()
    add({
        source = 'williamboman/mason.nvim',
        hooks = { post_checkout = function() vim.cmd('MasonUpdate') end },
    })

    add({ source = 'williamboman/mason-lspconfig.nvim' })
    add({ source = 'neovim/nvim-lspconfig' })

    local mason = require('mason')

    mason.setup()

    local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
    )

    local function on_attach(client, bufnr)
        local function set(lhs, rhs, desc, mode)
            local s = vim.keymap.set
            s(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr })
        end

        client.server_capabilities.documentFormattingProvider = false
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local fzf = require('fzf-lua')

        set('grr', fzf.lsp_references, 'references')
        set('grd', fzf.lsp_definitions, 'definitions')
        set('gri', fzf.lsp_implementations, 'implementations')
        set('gry', fzf.lsp_typedefs, 'typedefs')
        set('gra', fzf.lsp_code_actions, 'code actions')
        set('grc', fzf.lsp_incoming_calls, 'incoming calls')
        set('grn', vim.lsp.buf.rename, 'rename symbol')
        set('grC', fzf.lsp_outgoing_calls, 'outgoing calls')
        set('grs', fzf.lsp_document_symbols, 'document symbols')
        set('grS', fzf.lsp_workspace_symbols, 'workspace symbols')
        set('grx', fzf.lsp_document_diagnostics, 'documet diagnostics')
        set('grX', fzf.lsp_workspace_diagnostics, 'workspace diagnostics')
        set('<C-k>', vim.lsp.buf.signature_help, 'signature help', 'i')
    end

    require('mason-lspconfig').setup({
        ensure_installed = vim.tbl_keys(tools.servers),
        handlers = {
            function(server_name)
                local server = tools.servers[server_name] or {}
                server.capabilities = capabilities
                require('lspconfig')[server_name].setup(server)
            end,
        },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(e)
            local client = vim.lsp.get_client_by_id(e.data.client_id)
            if not client then return end
            on_attach(client, e.buf)
        end,
    })
end)

ltr(function()
    add({ source = 'tpope/vim-fugitive' })
    add({ source = 'tpope/vim-rhubarb' })
end)

ltr(function() add('christoomey/vim-tmux-navigator') end)

ltr(function()
    require('mini.clue').setup({
        triggers = {
            { mode = 'n', keys = 'g' },
            { mode = 'x', keys = 'g' },
            { mode = 'n', keys = '`' },
            { mode = 'x', keys = '`' },
            { mode = 'n', keys = '"' },
            { mode = 'x', keys = '"' },
            { mode = 'n', keys = "'" },
            { mode = 'x', keys = "'" },
            { mode = 'i', keys = '<C-r>' },
            { mode = 'c', keys = '<C-r>' },
            { mode = 'n', keys = '<C-w>' },
            { mode = 'i', keys = '<C-x>' },
            { mode = 'n', keys = 'z' },
            { mode = 'n', keys = '<leader>' },
            { mode = 'x', keys = '<leader>' },
            { mode = 'n', keys = '<localleader>' },
            { mode = 'x', keys = '<localleader>' },
            { mode = 'n', keys = '[' },
            { mode = 'n', keys = ']' },
        },
        clues = {
            { mode = 'n', keys = '[', desc = '+prev' },
            { mode = 'n', keys = ']', desc = '+next' },
            { mode = 'n', keys = '<leader>b', desc = '+buffers' },
            { mode = 'n', keys = '<leader>f', desc = '+files' },
            { mode = 'x', keys = '<leader>f', desc = '+files' },
            { mode = 'n', keys = '<leader>h', desc = '+hunks' },
            { mode = 'x', keys = '<leader>h', desc = '+hunks' },
            { mode = 'n', keys = '<leader>t', desc = '+tabs' },
            { mode = 'n', keys = '<leader><tab>', desc = '+tabs' },
            require('mini.clue').gen_clues.builtin_completion(),
            require('mini.clue').gen_clues.g(),
            require('mini.clue').gen_clues.marks(),
            require('mini.clue').gen_clues.registers(),
            require('mini.clue').gen_clues.windows(),
            require('mini.clue').gen_clues.z(),
        },
        window = {
            delay = 200,
            scroll_down = '<C-f>',
            scroll_up = '<C-b>',
            config = {
                width = 'auto',
            },
        },
    })

    vim.api.nvim_create_autocmd('BufReadPost', {
        group = vim.api.nvim_create_augroup(vim.g.whoami .. '/delete_unwanted_keymaps', {}),
        once = true,
        callback = function()
            for _, lhs in ipairs({ '[%', ']%', 'g%' }) do
                vim.keymap.del('n', lhs)
            end
        end,
    })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'grug-far' },
        group = vim.api.nvim_create_augroup(vim.g.whoami .. '/setup_grugfar_buf_triggers', {}),
        callback = function(e) require('mini.clue').ensure_buf_triggers(e.buf) end,
    })
end)
