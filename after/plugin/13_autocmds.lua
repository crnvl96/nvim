local H = {}

---
--- Helpers
---

H.map_split = function(buf_id, lhs, direction)
  local minifiles = require('mini.files')

  local function rhs()
    local window = minifiles.get_explorer_state().target_window
    if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then return end

    local new_target_window
    vim.api.nvim_win_call(window, function()
      vim.cmd(direction .. ' split')
      new_target_window = vim.api.nvim_get_current_win()
    end)

    minifiles.set_target_window(new_target_window)
    minifiles.go_in({ close_on_file = true })
  end

  Utils.Set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
end

---
--- Autocmds
---

Utils.Group('crnvl96-minifiles-keymaps', function(g)
  Utils.Autocmd('User', {
    group = g,
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local buf_id = args.data.buf_id

      H.map_split(buf_id, '<C-s>', 'belowright horizontal')
      H.map_split(buf_id, '<C-v>', 'belowright vertical')
    end,
  })
end)

Utils.Group('crnvl96-minifiles-ui', function(g)
  Utils.Autocmd('User', {
    group = g,
    pattern = 'MiniFilesWindowOpen',
    callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'rounded' }) end,
  })
end)

Utils.Group('crnvl96-lsp-on-attach', function(g)
  Utils.Autocmd('LspAttach', {
    group = g,
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  })
end)