return {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    init = function()
        vim.api.nvim_create_autocmd('FileType', {
            desc = 'Close gitsigns blame with Q',
            group = vim.api.nvim_create_augroup(vim.g.whoami .. '/gitsigns', { clear = true }),
            pattern = { 'gitsigns-blame' },
            callback = function(e) vim.keymap.set('n', 'q', '<Cmd>quit<CR>', { buffer = e.buf }) end,
        })
    end,
    opts = {
        signs = {
            add = { text = '▒' },
            untracked = { text = '▒' },
            change = { text = '▒' },
            delete = { text = '▒' },
            topdelete = { text = '▒' },
            changedelete = { text = '▒' },
        },
        signs_staged = {
            add = { text = '▒' },
            untracked = { text = '▒' },
            change = { text = '▒' },
            delete = { text = '▒' },
            topdelete = { text = '▒' },
            changedelete = { text = '▒' },
        },
        preview_config = { border = 'rounded' },
        attach_to_untracked = true,
        on_attach = function(buffer)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

            map('n', ']h', function()
                if vim.wo.diff then
                    vim.cmd.normal({ ']c', bang = true })
                else
                    gs.nav_hunk('next')
                end
            end, 'Next Hunk')
            map('n', '[h', function()
                if vim.wo.diff then
                    vim.cmd.normal({ '[c', bang = true })
                else
                    gs.nav_hunk('prev')
                end
            end, 'Prev Hunk')
            map('n', ']H', function() gs.nav_hunk('last') end, 'Last Hunk')
            map('n', '[H', function() gs.nav_hunk('first') end, 'First Hunk')
            map({ 'n', 'v' }, '<Leader>hs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
            map({ 'n', 'v' }, '<Leader>hr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
            map('n', '<Leader>hS', gs.stage_buffer, 'Stage Buffer')
            map('n', '<Leader>hu', gs.undo_stage_hunk, 'Undo Stage Hunk')
            map('n', '<Leader>hR', gs.reset_buffer, 'Reset Buffer')
            map('n', '<Leader>hp', gs.preview_hunk, 'Preview Hunk Inline')
            map('n', '<Leader>hb', function() gs.blame_line({ full = true }) end, 'Blame Line')
            map('n', '<Leader>hB', function() gs.blame() end, 'Blame Buffer')
            map('n', '<Leader>hd', gs.diffthis, 'Diff This')
            map('n', '<Leader>hD', function() gs.diffthis('~') end, 'Diff This ~')
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
        end,
    },
}
