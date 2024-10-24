return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile', 'VeryLazy' },
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '*' },
      delete = { text = '-' },
      topdelete = { text = '-' },
      changedelete = { text = '*' },
    },
    signs_staged = {
      add = { text = '+' },
      change = { text = '*' },
      delete = { text = '-' },
      topdelete = { text = '-' },
      changedelete = { text = '*' },
    },
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
      map('n', ']H', function() gs.nav_hunk('last') end, 'last hunk')
      map('n', '[H', function() gs.nav_hunk('first') end, 'first hunk')
      map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'stage hunk')
      map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'reset hunk')
      map('n', '<leader>ghS', gs.stage_buffer, 'stage buffer')
      map('n', '<leader>ghu', gs.undo_stage_hunk, 'undo stage hunk')
      map('n', '<leader>ghR', gs.reset_buffer, 'reset buffer')
      map('n', '<leader>ghp', gs.preview_hunk, 'preview hunk inline')
      map('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, 'blame line')
      map('n', '<leader>ghB', function() gs.blame() end, 'blame buffer')
      map('n', '<leader>ghd', gs.diffthis, 'diff this')
      map('n', '<leader>ghD', function() gs.diffthis('~') end, 'diff this ~')
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'gitsigns select hunk')
    end,
  },
}
