Utils.Group('crnvl96-auto-resize-window-splits', function(g)
  Utils.Autocmd('VimResized', {
    group = g,
    callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd('tabdo wincmd =')
      vim.cmd('tabnext ' .. current_tab)
    end,
  })
end)

Utils.Group('crnvl96-auto-sync', function(g)
  Utils.Autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = g,
    callback = function()
      if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
    end,
  })
end)

Utils.Group('crnvl96-auto-restore-last-position', function(g)
  Utils.Autocmd('BufReadPost', {
    group = g,
    callback = function(e)
      local position = vim.api.nvim_buf_get_mark(e.buf, [["]])
      local winid = vim.fn.bufwinid(e.buf)
      pcall(vim.api.nvim_win_set_cursor, winid, position)
    end,
  })
end)

Utils.Group('crnvl96-auto-open-qf-list', function(g)
  Utils.Autocmd('QuickFixCmdPost', {
    group = g,
    pattern = '[^lc]*',
    callback = function() vim.cmd('cwindow') end,
  })
end)

Utils.Group('crnvl96-auto-open-ll-list', function(g)
  Utils.Autocmd('QuickFixCmdPost', {
    group = g,
    pattern = 'l*',
    callback = function() vim.cmd('lwindow') end,
  })
end)

Utils.Group('crnvl96-handle-term-maps', function(g)
  Utils.Autocmd('TermOpen', {
    group = g,
    callback = function(event)
      local code_term_esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)

      for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
        Utils.Keymap('Navigate to/from terminals', {
          noremap = true,
          lhs = '<C-' .. key .. '>',
          rhs = function()
            local code_dir = vim.api.nvim_replace_termcodes('<C-' .. key .. '>', true, true, true)
            vim.api.nvim_feedkeys(code_term_esc .. code_dir, 't', false)
          end,
          mode = 't',
        })
      end

      Utils.Keymap('Enter normal mode in terminal', {
        noremap = true,
        lhs = '<C-r>',
        rhs = function() vim.api.nvim_feedkeys(code_term_esc, 't', false) end,
        mode = 't',
      })

      if vim.bo.filetype == '' then
        vim.api.nvim_set_option_value('filetype', 'terminal', { buf = event.buf })
        vim.cmd.startinsert()
      end
    end,
  })

  Utils.Autocmd('WinEnter', {
    group = g,
    callback = function()
      if vim.bo.filetype == 'terminal' then vim.cmd.startinsert() end
    end,
  })
end)

Utils.Group('crnvl96-handle-hlsearch', function(g)
  Utils.Autocmd('InsertEnter', {
    group = g,
    callback = function()
      vim.schedule(function() vim.cmd('nohlsearch') end)
    end,
  })
end)

Utils.Group('crnvl96-handle-yank', function(g)
  local cursorPreYank

  local function yank_cmd(cmd)
    return function()
      cursorPreYank = vim.api.nvim_win_get_cursor(0)
      return cmd
    end
  end

  Utils.Keymap('Yank (eol - preserve cursor)', {
    expr = true,
    lhs = 'Y',
    rhs = yank_cmd('yg_'),
  })

  Utils.Keymap('Yank (preserve cursor)', {
    expr = true,
    lhs = 'y',
    rhs = yank_cmd('y'),
    mode = { 'n', 'x' },
  })

  Utils.Autocmd('TextYankPost', {
    group = g,
    callback = function()
      (vim.hl or vim.highlight).on_yank()
      if vim.v.event.operator == 'y' and cursorPreYank then vim.api.nvim_win_set_cursor(0, cursorPreYank) end
    end,
  })
end)
