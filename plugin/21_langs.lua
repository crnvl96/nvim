---@diagnostic disable: undefined-global

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    add {
        source = 'nvim-treesitter/nvim-treesitter',
        checkout = 'main',
        hooks = {
            post_checkout = function()
                vim.cmd 'TSUpdate'
            end,
        },
    }

    add {
        source = 'nvim-treesitter/nvim-treesitter-textobjects',
        checkout = 'main',
    }

    -- stylua: ignore
    local treesit_langs = {
        -- note: parsers for c, lua, vim, vimdoc, query and markdown are already included in neovim
        'bash', 'css', 'diff', 'go', 'html',
        'javascript', 'json', 'python', 'regex',
        'toml', 'tsx', 'typescript', 'yaml',
        'javascript', 'typescript',
    }

    local parsers = vim.iter(treesit_langs)
        :filter(function(item)
            return #vim.api.nvim_get_runtime_file('parser/' .. item .. '.*', false) == 0
        end)
        :flatten()
        :totable()

    local fts = vim.iter(treesit_langs)
        :map(function(item)
            return vim.treesitter.language.get_filetypes(item)
        end)
        :flatten()
        :totable()

    require('nvim-treesitter').install(parsers)

    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('crnvl96-nvim-treesitter', {}),
        pattern = fts,
        callback = function(ev)
            vim.treesitter.start(ev.buf)
        end,
    })
end)

now(function()
    add 'neovim/nvim-lspconfig'

    vim.lsp.enable { 'lua_ls', 'pyright', 'ruff', 'ts_ls', 'biome', 'eslint' }

    local set = vim.keymap.set

    set('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
    set('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>')
    set('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
    set('n', '<leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Actions' })

    set('n', '<leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Definition' })
    set('n', '<leader>li', '<Cmd>lua vim.lsp.buf.implementation()<CR>', { desc = 'Implementation' })
    set('n', '<leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename' })
    set('n', '<leader>lr', '<Cmd>lua vim.lsp.buf.references()<CR>', { desc = 'References' })
    set('n', '<leader>lS', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { desc = 'Workspace Symbols' })
    set('n', '<leader>ly', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', { desc = 'Type definition' })
    set('n', '<leader>ls', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', { desc = 'Document Symbols' })
    set('n', '<leader>lx', '<Cmd>lua vim.diagnostic.setqflist()<CR>', { desc = 'Diagnostics' })
    set('n', '<leader>lf', '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>', { desc = 'Format' })
end)

later(function()
    add 'stevearc/conform.nvim'

    local conf = require 'conform'
    local util = require 'conform.util'

    local web = function()
        if util.root_file { 'biome.json', 'biome.jsonc' } then
            return { 'biome' }
        else
            return { 'prettier' }
        end
    end

    local prettier = function()
        return { 'prettier' }
    end

    local python = function()
        return { 'rufff_organize_imports', 'ruff_fix', 'ruff_format' }
    end

    local lua = function()
        return { 'stylua' }
    end

    local default = function()
        return { 'trim_whitespace', 'trim_newline' }
    end

    vim.g.autoformat = true

    local fmt_on_save = function()
        if not vim.g.autoformat then
            return nil
        end

        return {}
    end

    conf.setup {
        notify_on_error = false,
        notify_no_formatters = false,
        default_format_opts = {
            lsp_format = 'fallback',
            timeout_ms = 1000,
        },
        formatters = {
            stylua = {
                require_cwd = true,
            },
            prettier = {
                require_cwd = false,
            },
        },
        formatters_by_ft = {
            ['_'] = default,
            javascript = web,
            typescript = web,
            python = python,
            lua = lua,
            json = prettier,
            jsonc = prettier,
            yaml = prettier,
            markdown = prettier,
        },
        format_on_save = fmt_on_save,
    }

    local toggle_fmt_on_save = function()
        vim.g.autoformat = not vim.g.autoformat
    end

    vim.keymap.set('n', [[\f]], toggle_fmt_on_save, { desc = 'Toggle Autofmt' })
end)
