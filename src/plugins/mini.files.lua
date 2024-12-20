local function map_split(buf_id, lhs, direction)
  local minifiles = require('mini.files')

  local function rhs()
    local window = minifiles.get_explorer_state().target_window

    -- Noop if the explorer isn't open or the cursor is on a directory.
    if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then return end

    -- Make a new window and set it as target.
    local new_target_window
    vim.api.nvim_win_call(window, function()
      vim.cmd(direction .. ' split')
      new_target_window = vim.api.nvim_get_current_win()
    end)

    minifiles.set_target_window(new_target_window)

    -- Go in and close the explorer.
    minifiles.go_in({ close_on_file = true })
  end

  vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
end

require('mini.files').setup({
  content = {
    filter = function(entry) return entry.fs_type ~= 'file' or entry.name ~= '.DS_Store' end,
    sort = function(entries)
      local function compare_alphanumerically(e1, e2)
        -- Put directories first.
        if e1.is_dir and not e2.is_dir then return true end
        if not e1.is_dir and e2.is_dir then return false end
        -- Order numerically based on digits if the text before them is equal.
        if e1.pre_digits == e2.pre_digits and e1.digits ~= nil and e2.digits ~= nil then
          return e1.digits < e2.digits
        end
        -- Otherwise order alphabetically ignoring case.
        return e1.lower_name < e2.lower_name
      end

      local sorted = vim.tbl_map(function(entry)
        local pre_digits, digits = entry.name:match('^(%D*)(%d+)')
        if digits ~= nil then digits = tonumber(digits) end

        return {
          fs_type = entry.fs_type,
          name = entry.name,
          path = entry.path,
          lower_name = entry.name:lower(),
          is_dir = entry.fs_type == 'directory',
          pre_digits = pre_digits,
          digits = digits,
        }
      end, entries)
      table.sort(sorted, compare_alphanumerically)
      -- Keep only the necessary fields.
      return vim.tbl_map(function(x) return { name = x.name, fs_type = x.fs_type, path = x.path } end, sorted)
    end,
  },
  mappings = {
    close = 'q',
    go_in = '',
    go_in_plus = '<CR>',
    go_out = '',
    go_out_plus = '<BS>',
    mark_goto = "'",
    mark_set = 'm',
    reset = '_',
    reveal_cwd = '@',
    show_help = 'g?',
    synchronize = '=',
    trim_left = '<',
    trim_right = '>',
  },
  windows = { width_nofocus = 25 },
  -- Move stuff to the minifiles trash instead of it being gone forever.
  options = { permanent_delete = false },
})

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('crnvl96-mini-files-ui', {}),
  pattern = 'MiniFilesWindowOpen',
  callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'double' }) end,
})

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('crnvl96-mini-files-mappings', {}),
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local buf_id = args.data.buf_id
    map_split(buf_id, '<C-w>s', 'belowright horizontal')
    map_split(buf_id, '<C-w>v', 'belowright vertical')
  end,
})

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('crnvl96-mini-files-bookmarks', {}),
  pattern = 'MiniFilesExplorerOpen',
  callback = function()
    MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
    MiniFiles.set_bookmark('m', vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim', { desc = 'mini.nvim' })
    MiniFiles.set_bookmark('p', vim.fn.stdpath('data') .. '/site/pack/deps/opt', { desc = 'Plugins' })
    MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working directory' })
  end,
})

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('crnvl96-mini-files-trash-bookmark', {}),
  pattern = 'MiniFilesActionDelete',
  callback = function() MiniFiles.set_bookmark('t', vim.fn.stdpath('data') .. '/mini.files/trash', { desc = 'Trash' }) end,
})
