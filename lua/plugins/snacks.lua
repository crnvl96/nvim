return {
  'folke/snacks.nvim',
  priority = 999,
  lazy = false,
  init = function()
    vim.g.autofmt = true

    au('User', {
      pattern = 'VeryLazy',
      group = group('crnvl96-snacks', { clear = true }),
      callback = function()
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd

        local toggle_format_on_save = {
          name = 'Format on save',
          get = function() return vim.g.autofmt end,
          set = function(s) vim.g.autofmt = s end,
        }

        local toggle_conceal = {
          on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
          off = 0,
        }

        -- Controls the formatting action handled by `conform.nvim`
        Snacks.toggle(toggle_format_on_save):map('<leader>uf')
        Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
        Snacks.toggle.diagnostics():map('<leader>ud')
        Snacks.toggle.line_number():map('<leader>ul')
        Snacks.toggle.option('conceallevel', toggle_conceal):map('<leader>uc')
        Snacks.toggle.treesitter():map('<leader>uT')
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
        Snacks.toggle.inlay_hints():map('<leader>uh')
        Snacks.toggle.indent():map('<leader>ug')
        Snacks.toggle.dim():map('<leader>uD')
      end,
    })
  end,
  opts = {
    bigfile = { size = bigfile },
    notifier = { enabled = true },
    scroll = { enabled = true },
    quickfile = { enabled = true },
    words = { notify_jump = true },
    styles = {
      notification = {
        wo = { wrap = true },
        zindex = 999,
      },
    },
  },
  keys = {
    { '<leader>ch', function() Snacks.notifier.show_history() end, desc = 'notification history' },
    { '<leader>cf', function() Snacks.rename.rename_file() end, desc = 'rename file' },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'delete buffer' },
    { '<leader>bx', function() Snacks.bufdelete.all() end, desc = 'delete all buffers' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'delete other buffers' },
    { '<leader>bb', function() vim.cmd('b#') end, desc = 'goto last buffer' },
    { '<leader>gw', function() Snacks.gitbrowse() end, desc = 'git browse' },
    {
      '<leader>gy',
      function()
        Snacks.gitbrowse({ open = function(url) vim.fn.setreg('+', url) end, notify = false })
      end,
      desc = 'git browse (copy)',
      mode = { 'n', 'v' },
    },
    { '<leader>gb', function() Snacks.git.blame_line() end, desc = 'git blame line' },
    { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'lazygit current file history' },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'lazygit' },
    { '<leader>gl', function() Snacks.lazygit.log() end, desc = 'lazygit log (cwd)' },
    { '<c-t>', function() Snacks.terminal(nil, {}) end, desc = 'terminal (cwd)' },
    { '<c-t>', '<cmd>close<cr>', desc = 'hide terminal', mode = 't' },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'next reference', mode = { 'n', 't' } },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'prev reference', mode = { 'n', 't' } },
  },
}
