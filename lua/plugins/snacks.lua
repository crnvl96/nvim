return {
  'folke/snacks.nvim',
  lazy = false,
  config = function()
    local M = require('config.functions')
    local Constants = require('config.constants')

    require('snacks').setup({

      bigfile = { size = Constants.bigfile },
      quickfile = { enabled = true },
      words = { notify_jump = true },
      notifier = { enabled = true },
    })

    _G.dd = function(...) Snacks.debug.inspect(...) end
    _G.bt = function() Snacks.debug.backtrace() end
    vim.print = _G.dd

    local toggle_conceal = {
      on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
      off = 0,
    }

    if M.has('conform.nvim') then
      local toggle_format_on_save = {
        name = 'Format on save',
        get = function() return Constants.autoformat end,
        set = function(s) Constants.autoformat = s end,
      }

      -- Controls the formatting action handled by `conform.nvim`
      Snacks.toggle(toggle_format_on_save):map('<leader>uf')
    end

    Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
    Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>ul')
    Snacks.toggle.diagnostics():map('<leader>ud')
    Snacks.toggle.option('conceallevel', toggle_conceal):map('<leader>uc')
    Snacks.toggle.treesitter():map('<leader>ut')
    Snacks.toggle.indent():map('<leader>ug')
  end,
  keys = {
    { '<leader>cf', function() Snacks.rename.rename_file() end, desc = 'rename file' },
    { '<leader>ch', function() Snacks.notifier.show_history() end, desc = 'show history' },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'delete buffer' },
    { '<leader>bx', function() Snacks.bufdelete.all() end, desc = 'delete all buffers' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'delete other buffers' },
    { '<leader>bb', function() vim.cmd('b#') end, desc = 'goto last buffer' },
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
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'next reference', mode = { 'n', 't' } },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'prev reference', mode = { 'n', 't' } },
  },
}
