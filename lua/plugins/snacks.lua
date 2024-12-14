return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    HasGlobalVar('autoformat')
    HasGlobalVar('bigfile')

    require('snacks').setup({
      bigfile = { size = vim.g.bigfile },
      quickfile = { enabled = true },
      words = { notify_jump = true },
      notifier = { enabled = true },
      toggle = { which_key = false },
      statuscolumn = { enabled = true },
      styles = {
        notification = {
          border = 'double',
          zindex = 999,
        },
        notification_history = {
          border = 'double',
          zindex = 999,
        },
      },
    })

    _G.dd = function(...) Snacks.debug.inspect(...) end

    _G.bt = function() Snacks.debug.backtrace() end

    vim.print = _G.dd

    if Has('conform.nvim') then
      Snacks.toggle({
        name = 'Format on save',
        get = function() return vim.g.autoformat end,
        set = function(s) vim.g.autoformat = s end,
      }):map('<leader>uf', { desc = 'toggle: format on save' })
    end

    if Has('render-markdown.nvim') then
      Snacks.toggle({
        name = 'render markdown',
        get = function() return require('render-markdown.state').enabled end,
        set = function(enabled)
          local m = require('render-markdown')
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map('<leader>um', { desc = 'toggle: render markdown' })
    end

    Snacks.toggle
      .option('relativenumber', { name = 'Relative Number' })
      :map('<leader>uL', { desc = 'toggle: relative number' })

    Snacks.toggle.option('conceallevel', { on = 2, off = 0 }):map('<leader>uc', { desc = 'toggle: conceal' })

    Snacks.toggle
      .option('background', { off = 'light', on = 'dark', name = 'background' })
      :map('<leader>ub', { desc = 'toggle: background' })

    Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us', { desc = 'toggle: spelling' })
    Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw', { desc = 'toggle: wrap' })
    Snacks.toggle.diagnostics():map('<leader>ud', { desc = 'toggle: diagnostics' })
    Snacks.toggle.line_number():map('<leader>ul', { desc = 'toggle: line numbers' })
    Snacks.toggle.treesitter():map('<leader>uT', { desc = 'toggle: treesitter' })
    Snacks.toggle.inlay_hints():map('<leader>uh', { desc = 'toggle: inlay hints' })
    Snacks.toggle.indent():map('<leader>ug', { desc = 'toggle: indent' })
    Snacks.toggle.dim():map('<leader>uD', { desc = 'toggle: dim' })
  end,
  keys = {
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'snacks: next reference', mode = { 'n', 't' } },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'snacks: prev reference', mode = { 'n', 't' } },

    { '<leader><space>', function() Snacks.zen.zoom() end, desc = 'snacks: toggle zoom' },

    { '<leader>ch', function() Snacks.notifier.show_history() end, desc = 'lzg: show history' },
    { '<leader>cx', function() Snacks.notifier.hide() end, desc = 'snacks: dismiss all notifications' },

    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'snacks: delete buffer' },
    { '<leader>bx', function() Snacks.bufdelete.all() end, desc = 'snacks: delete all buffers' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'snacks: delete other buffers' },
    { '<leader>bb', function() vim.cmd('b#') end, desc = 'snacks: goto last buffer' },

    {
      '<leader>gy',
      function()
        Snacks.gitbrowse({ open = function(url) vim.fn.setreg('+', url) end, notify = false })
      end,
      desc = 'lzg: browse (copy)',
      mode = { 'n', 'v' },
    },

    { '<leader>gb', function() Snacks.git.blame_line() end, desc = 'lzg: blame line' },
    { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'lzg: current file history' },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'lazygit' },
    { '<leader>gl', function() Snacks.lazygit.log() end, desc = 'lzg: log (cwd)' },
  },
}
