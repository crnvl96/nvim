Utils.Group('crnvl96-minifiles-keymaps', function(g)
  Utils.Autocmd('User', {
    group = g,
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local minifiles = require('mini.files')
      local buf = args.data.buf_id

      local map_split = function(lhs, direction)
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

        Utils.Keymap('Split ' .. string.sub(direction, 12), { buffer = buf, lhs = lhs, rhs = rhs })
      end

      map_split('<C-s>', 'belowright horizontal')
      map_split('<C-v>', 'belowright vertical')
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

Utils.Group('crnvl96-handle-linters', function(g)
  local linters = {
    lua = {
      linters = { 'selene' },
      cond = function(buf) return vim.fs.root(buf, { 'selene.toml' }) ~= nil end,
    },
  }

  Utils.Autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
    group = g,
    callback = function(e)
      local ft = vim.bo[e.buf].ft
      local linter = linters[ft]

      if (linter and not linter.cond) or (linter and linter.cond(e.buf)) then
        require('lint').try_lint(linter.linters)
      end
    end,
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
