return {
  'folke/snacks.nvim',
  priority = 999,
  lazy = false,
  init = function()
    au('User', {
      pattern = 'VeryLazy',
      group = group('crnvl96-snacks', { clear = true }),
      callback = function()
        vim.g.autofmt = true

        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd

        require('mini.misc').setup_termbg_sync()
        require('mini.misc').setup_auto_root()
        require('mini.misc').setup_restore_cursor()

        Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
        Snacks.toggle.diagnostics():map('<leader>ud')
        Snacks.toggle.line_number():map('<leader>ul')
        Snacks.toggle.option('conceallevel', { off = 0, on = 2 }):map('<leader>uc')
        Snacks.toggle.treesitter():map('<leader>uT')
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
        Snacks.toggle.inlay_hints():map('<leader>uh')

        Snacks.toggle({
          name = 'Format on save',
          get = function() return vim.g.autofmt end,
          set = function(state) vim.g.autofmt = state end,
        }):map('<leader>uf')
      end,
    })
  end,
  opts = {
    bigfile = {
      size = 0.5 * 1024 * 1024, -- 0.5MB
    },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    dashboard = {
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = {
      notify_jump = true,
    },
    scratch = {
      ft = 'markdown',
    },
    styles = {
      notification = {
        wo = { wrap = true },
        border = 'double',
        zindex = 999,
      },
      ['notification.history'] = {
        border = 'double',
        wo = { wrap = true },
        zindex = 999,
        width = 0.80,
        height = 0.85,
      },
      scratch = {
        position = 'right',
        border = 'double',
      },
    },
  },
  keys = {
    { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
    { '<leader>ch', function() Snacks.notifier.show_history() end, desc = 'Notification History' },
    { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File' },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
    { '<leader>bD', function() Snacks.bufdelete.all() end, desc = 'Delete all Buffers' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete other Buffers' },
    { '<leader>bb', function() vim.cmd('b#') end, desc = 'Goto last Buffer' },
    { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse' },
    {
      '<leader>gY',
      function()
        Snacks.gitbrowse({ open = function(url) vim.fn.setreg('+', url) end, notify = false })
      end,
      desc = 'Git Browse (Copy)',
      mode = { 'n', 'v' },
    },
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
