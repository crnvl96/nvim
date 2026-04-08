vim.api.nvim_create_autocmd('TextYankPost', {
  group = Config.gr,
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdlineEnter' }, {
  group = Config.gr,
  callback = vim.schedule_wrap(function() vim.cmd.nohlsearch() end),
})

vim.api.nvim_create_autocmd('BufReadPre', {
  group = Config.gr,
  callback = function(e)
    vim.api.nvim_create_autocmd('FileType', {
      group = Config.gr,
      buffer = e.buf,
      once = true,
      callback = function()
        if vim.bo.buftype ~= '' then return end
        if vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.bo.filetype) then return end
        local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
        if cursor_line > 1 then return end
        local mark_line = vim.api.nvim_buf_get_mark(0, [["]])[1]
        local n_lines = vim.api.nvim_buf_line_count(0)
        if not (1 <= mark_line and mark_line <= n_lines) then return end
        vim.cmd([[normal! g`"zv]])
        vim.cmd([[normal! zz]])
      end,
    })
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = Config.gr,
  callback = function(e)
    local bufnr = e.buf
    local filetype = vim.bo[bufnr].ft
    local types = { 'help', 'checkhealth', 'vim', 'fugitive', 'qf', '' }
    for _, b in ipairs(types) do
      if filetype == b then
        vim.keymap.set('n', 'q', function() vim.api.nvim_command('close') end, { buffer = true })
      end
    end
  end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = Config.gr,
  pattern = '[^l]*',
  command = 'copen',
})

vim.api.nvim_create_autocmd('CmdlineChanged', {
  group = Config.gr,
  callback = Config.debounce(
    vim.schedule_wrap(function()
      local function should_enable_autocomplete()
        local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
        local cmdline_type = vim.fn.getcmdtype()
        -- return cmdline_type == '/' or cmdline_type == '?' or (cmdline_type == ':' and cmdline_cmd and #cmdline_cmd >= 2)
        return cmdline_type == '/'
          or cmdline_type == '?'
          or cmdline_type == '!'
          or (
            cmdline_type == ':'
            and (
              cmdline_cmd == 'find'
              or cmdline_cmd == 'fin'
              or cmdline_cmd == 'help'
              or cmdline_cmd == 'h'
              or cmdline_cmd == 'buffer'
              or cmdline_cmd == 'b'
            )
          )
      end
      if should_enable_autocomplete() then vim.fn.wildtrigger() end
    end),
    500
  ),
})
