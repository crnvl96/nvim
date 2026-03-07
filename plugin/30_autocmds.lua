Config.now(function()
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = Config.gr,
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = Config.gr,
    callback = function()
      if vim.o.buftype ~= 'nofile' then
        vim.cmd('checktime')
      end
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = Config.gr,
    pattern = { 'man' },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = Config.gr,
    pattern = { 'json', 'jsonc', 'json5' },
    callback = function()
      vim.opt_local.conceallevel = 0
    end,
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    group = Config.gr,
    callback = function(event)
      if event.match:match('^%w%w+:[\\/][\\/]') then
        return
      end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
  })

  vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = Config.gr,
    pattern = '[^l]*',
    command = 'cwindow',
  })

  vim.api.nvim_create_autocmd('VimResized', {
    group = Config.gr,
    callback = function()
      local current_tab = vim.api.nvim_get_current_tabpage()
      vim.cmd('tabdo wincmd =')
      vim.api.nvim_set_current_tabpage(current_tab)
    end,
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    callback = function(e)
      local bufnr = e.buf
      local filetype = vim.bo[bufnr].ft
      local types = { 'help', 'checkhealth', 'vim', '' }
      for _, b in ipairs(types) do
        if filetype == b then
          vim.keymap.set('n', 'q', function()
            vim.api.nvim_command('close')
          end, { buffer = true })
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdlineEnter' }, {
    group = Config.gr,
    callback = vim.schedule_wrap(function()
      vim.cmd.nohlsearch()
    end),
  })
end)
