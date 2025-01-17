vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-on-yank', { clear = true }),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('crnvl96-resize-splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl96-auto-last-position', { clear = true }),
  callback = function(e)
    local position = vim.api.nvim_buf_get_mark(e.buf, [["]])
    local winid = vim.fn.bufwinid(e.buf)
    pcall(vim.api.nvim_win_set_cursor, winid, position)
  end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('crnvl96-auto-open-qf', { clear = true }),
  pattern = '[^lc]*',
  callback = function() vim.cmd('cwindow') end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('crnvl96-auto-open-lc', { clear = true }),
  pattern = 'l*',
  callback = function() vim.cmd('lwindow') end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Automatically Split help Buffers to the right',
  pattern = 'help',
  command = 'wincmd L',
})

local function augroup(name, fnc) fnc(vim.api.nvim_create_augroup(name, { clear = true })) end

augroup('ibhagwan/ToggleSearchHL', function(g)
  vim.api.nvim_create_autocmd('InsertEnter', {
    group = g,
    callback = function()
      vim.schedule(function() vim.cmd('nohlsearch') end)
    end,
  })

  vim.api.nvim_create_autocmd('CursorMoved', {
    group = g,
    callback = function()
      -- No bloat lua adpatation of: https://github.com/romainl/vim-cool
      local view, rpos = vim.fn.winsaveview(), vim.fn.getpos('.')
      -- Move the cursor to a position where (whereas in active search) pressing `n`
      -- brings us to the original cursor position, in a forward search / that means
      -- one column before the match, in a backward search ? we move one col forward
      vim.cmd(
        string.format(
          'silent! keepjumps go%s',
          (vim.fn.line2byte(view.lnum) + view.col + 1 - (vim.v.searchforward == 1 and 2 or 0))
        )
      )
      -- Attempt to goto next match, if we're in an active search cursor position
      -- should be equal to original cursor position
      local ok, _ = pcall(vim.cmd, 'silent! keepjumps norm! n')
      local insearch = ok
        and (function()
          local npos = vim.fn.getpos('.')
          return npos[2] == rpos[2] and npos[3] == rpos[3]
        end)()
      -- restore original view and position
      vim.fn.winrestview(view)
      if not insearch then vim.schedule(function() vim.cmd('nohlsearch') end) end
    end,
  })
end)
