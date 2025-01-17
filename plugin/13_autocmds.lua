local function augroup(name, fnc) fnc(vim.api.nvim_create_augroup(name, { clear = true })) end

local autocmd = vim.api.nvim_create_autocmd
local set = vim.keymap.set

augroup('crnvl96-auto-resize-window-splits', function(g)
  autocmd('VimResized', {
    group = g,
    callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd('tabdo wincmd =')
      vim.cmd('tabnext ' .. current_tab)
    end,
  })
end)

augroup('crnvl96-auto-restore-last-position', function(g)
  autocmd('BufReadPost', {
    group = g,
    callback = function(e)
      local position = vim.api.nvim_buf_get_mark(e.buf, [["]])
      local winid = vim.fn.bufwinid(e.buf)
      pcall(vim.api.nvim_win_set_cursor, winid, position)
    end,
  })
end)

augroup('crnvl96-auto-open-qflist', function(g)
  autocmd('QuickFixCmdPost', {
    group = g,
    pattern = '[^lc]*',
    callback = function() vim.cmd('cwindow') end,
  })

  autocmd('QuickFixCmdPost', {
    group = g,
    pattern = 'l*',
    callback = function() vim.cmd('lwindow') end,
  })
end)

augroup(
  'crnvl-handle-help-buffer-position',
  function(g)
    autocmd('FileType', {
      group = g,
      pattern = 'help',
      command = 'wincmd L',
    })
  end
)

augroup('crnvl96-handle-term-maps', function(g)
  autocmd('TermOpen', {
    group = g,
    pattern = '*',
    callback = function(event)
      vim.o.cursorline = false
      local code_term_esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)

      for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
        vim.keymap.set('t', '<C-' .. key .. '>', function()
          local code_dir = vim.api.nvim_replace_termcodes('<C-' .. key .. '>', true, true, true)
          vim.api.nvim_feedkeys(code_term_esc .. code_dir, 't', true)
        end, { noremap = true })
      end

      if vim.bo.filetype == '' then
        vim.api.nvim_set_option_value('filetype', 'terminal', { buf = event.buf })
        if vim.g.catgoose_terminal_enable_startinsert == 1 then vim.cmd.startinsert() end
      end
    end,
  })

  autocmd('WinEnter', {
    group = g,
    pattern = '*',
    callback = function()
      if vim.bo.filetype == 'terminal' and vim.g.catgoose_terminal_enable_startinsert then vim.cmd.startinsert() end
    end,
  })
end)

augroup('crnvl96-handle-hlsearch', function(g)
  autocmd('InsertEnter', {
    group = g,
    callback = function()
      vim.schedule(function() vim.cmd('nohlsearch') end)
    end,
  })

  autocmd('CursorMoved', {
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

augroup('crnvl96-handle-yank', function(g)
  local cursorPreYank

  local function yank_cmd(cmd)
    return function()
      cursorPreYank = vim.api.nvim_win_get_cursor(0)
      return cmd
    end
  end

  set('n', 'Y', yank_cmd('yg_'), { expr = true })
  set({ 'n', 'x' }, 'y', yank_cmd('y'), { expr = true })

  autocmd('TextYankPost', {
    group = g,
    callback = function()
      (vim.hl or vim.highlight).on_yank()
      if vim.v.event.operator == 'y' and cursorPreYank then vim.api.nvim_win_set_cursor(0, cursorPreYank) end
    end,
  })
end)
