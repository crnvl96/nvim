local neogit = require('neogit')
neogit.setup()

local gitsigns = require('gitsigns')
gitsigns.setup({
    signs = {
        add = { text = '▒' },
        change = { text = '▒' },
        delete = { text = '▒' },
        topdelete = { text = '▒' },
        changedelete = { text = '▒' },
        untracked = { text = '▒' },
    },
    signs_staged = {
        add = { text = '▒' },
        change = { text = '▒' },
        delete = { text = '▒' },
        topdelete = { text = '▒' },
        changedelete = { text = '▒' },
        untracked = { text = '▒' },
    },
    on_attach = function(bufnr)
        local function handle_nav_fwd()
            return vim.wo.diff and vim.cmd.normal({ ']c', bang = true }) or gitsigns.nav_hunk('next')
        end

        local function handle_nav_bck()
            return vim.wo.diff and vim.cmd.normal({ '[c', bang = true }) or gitsigns.nav_hunk('prev')
        end

        local function stage_selected_hunk_part() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end
        local function reset_selected_hunk_part() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end
        local function blame_line() gitsigns.blame_line({ full = true }) end
        local function diff_from_head() gitsigns.diffthis('~') end

        vim.keymap.set('n', ']c', handle_nav_fwd, { desc = 'next hunk' })
        vim.keymap.set('n', '[c', handle_nav_bck, { desc = 'prev hunk' })
        vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'stage hunk', buffer = bufnr })
        vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'reset hunk', buffer = bufnr })
        vim.keymap.set('n', '<leader>hs', stage_selected_hunk_part, { desc = 'stage hunk', buffer = bufnr })
        vim.keymap.set('n', '<leader>hr', reset_selected_hunk_part, { desc = 'reset hunk', buffer = bufnr })
        vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'stage buffer', buffer = bufnr })
        vim.keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'undo stage hunk', buffer = bufnr })
        vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'reset buffer', buffer = bufnr })
        vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk_inline, { desc = 'preview hunk', buffer = bufnr })
        vim.keymap.set('n', '<leader>hb', blame_line, { desc = 'blame line', buffer = bufnr })
        vim.keymap.set('n', '<leader>hB', gitsigns.blame, { desc = 'blame', buffer = bufnr })
        vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'diff this', buffer = bufnr })
        vim.keymap.set('n', '<leader>hD', diff_from_head, { desc = 'diff this against ~', buffer = bufnr })
        vim.keymap.set('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'toggle deleted lines', buffer = bufnr })
        vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'blame line', buffer = bufnr })
        vim.keymap.set({ 'x', 'o' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select hunk', buffer = bufnr })
    end,
})
