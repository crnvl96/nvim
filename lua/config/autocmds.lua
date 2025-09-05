local U = require('utils')

U.augroup(
  'crnvl96-post-grep',
  function(g)
    U.aucmd('QuickFixCmdPost', {
      group = g,
      pattern = '*grep*',
      command = 'cwindow',
    })
  end
)

U.augroup(
  'crnvl96-termoptions',
  function(g)
    U.aucmd('TermOpen', {
      group = g,
      command = 'setlocal listchars= nonumber norelativenumber',
    })
  end
)

U.augroup('crnvl96-last-location', function(g)
  U.aucmd('BufReadPost', {
    group = g,
    callback = function(e)
      local mark = vim.api.nvim_buf_get_mark(e.buf, '"')
      local line_count = vim.api.nvim_buf_line_count(e.buf)
      if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
    end,
  })
end)

U.augroup(
  'crnvl96-resize-windows',
  function(g)
    U.aucmd('VimResized', {
      group = g,
      command = 'tabdo wincmd =',
    })
  end
)
