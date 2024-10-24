return {
  'folke/snacks.nvim',
  priority = 999,
  lazy = false,
  init = function()
    au('User', {
      pattern = 'VeryLazy',
      group = group('crnvl96-snacks', { clear = true }),
      callback = function()
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd
      end,
    })
  end,
  opts = {
    bigfile = { size = 0.5 * 1024 * 1024 },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    words = { notify_jump = true },
    scratch = { ft = 'md' },
    styles = {
      notification = {
        wo = { wrap = true },
        zindex = 999,
      },
    },
  },
	-- stylua: ignore
  keys = {
    { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
    { '<leader>ch', function() Snacks.notifier.show_history() end, desc = 'Notification History' },
    { '<leader>lR', function() Snacks.rename.rename_file() end, desc = 'Rename File' },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
    { '<leader>bD', function() Snacks.bufdelete.all() end, desc = 'Delete all Buffers' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete other Buffers' },
    { '<leader>bb', function() vim.cmd('b#') end, desc = 'Goto last Buffer' },
    { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse' },
    { '<leader>gY', function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg('+', url) end, notify = false }) end, desc = 'Git Browse (Copy)', mode = { 'n', 'v' } },
    { '<leader>gb', function() Snacks.git.blame_line() end, desc = 'Git Blame Line' },
    { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Lazygit Current File History' },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
    { '<leader>gl', function() Snacks.lazygit.log() end, desc = 'Lazygit Log (cwd)' },
    { '<C-t>', function() Snacks.terminal(nil, {}) end, desc = 'Terminal (cwd)' },
    { '<C-t>', '<cmd>close<cr>', desc = 'Hide Terminal', mode = 't' },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
  },
}
