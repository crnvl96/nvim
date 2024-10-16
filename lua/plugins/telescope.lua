local build = function(args)
    local obj = vim.system({ 'make', '-C', args.path }, { text = true }):wait()
    vim.print(vim.inspect(obj))
end

MiniDeps.add({
    source = 'nvim-telescope/telescope.nvim',
    depends = {
        { source = 'nvim-lua/plenary.nvim' },
        { source = 'nvim-telescope/telescope-ui-select.nvim' },
        { source = 'nvim-treesitter/nvim-treesitter' },
        {
            source = 'nvim-telescope/telescope-fzf-native.nvim',
            hooks = {
                post_install = function(args)
                    MiniDeps.later(function() build(args) end)
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

On_lsp_attach = function(client, bufnr)
    local map = function(method, lhs, rhs, desc, mode)
        local setmap = function() vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr }) end
        if client.supports_method(method) then setmap() end
    end

    vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    local m = vim.lsp.protocol.Methods

    map(m.textDocument_definition, 'gd', function() wrap('lsp_definitions') end, 'Go to definition')
    map(m.textDocument_references, 'gR', function() wrap('lsp_references') end, 'List references')
    map(m.textDocument_implementation, 'gi', function() wrap('lsp_implementations') end, 'List implementations')
    map(m.textDocument_typeDefinition, 'gy', function() wrap('lsp_type_definitions') end, 'Go to type definition')
    map(m.textDocument_codeAction, 'ga', vim.lsp.buf.code_action, 'List code actions')
    map(m.textDocument_rename, 'gn', vim.lsp.buf.code_action, 'Rename symbol under cursor')
end

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
