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
