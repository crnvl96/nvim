return {
  on_attach = function(client, buf_id)
    -- Reduce unnecessarily long list of completion triggers for better
    -- 'mini.completion' experience
    client.server_capabilities.completionProvider.triggerCharacters = { '.', ':', '#', '(' }

    -- LuaLS "Go to source" =======================================================
    -- Deal with the fact that LuaLS in case of `local a = function()` style
    -- treats both `a` and `function()` as definitions of `a`.
    -- Do this by tweaking `vim.lsp.buf_definition` mapping as client-local
    -- handlers are ignored after https://github.com/neovim/neovim/pull/30877
    local filter_line_locations = function(locations)
      local present, res = {}, {}
      for _, l in ipairs(locations) do
        local t = present[l.filename] or {}
        if not t[l.lnum] then
          table.insert(res, l)
          t[l.lnum] = true
        end
        present[l.filename] = t
      end
      return res
    end

    local show_location = function(location)
      local buf = location.bufnr or vim.fn.bufadd(location.filename)
      vim.bo[buf_id].buflisted = true
      vim.api.nvim_win_set_buf(0, buf)
      vim.api.nvim_win_set_cursor(0, { location.lnum, location.col - 1 })
      vim.cmd('normal! zv')
    end

    local on_list = function(args)
      local items = filter_line_locations(args.items)
      if #items > 1 then
        vim.fn.setqflist({}, ' ', { title = 'LSP locations', items = items })
        return vim.cmd('botright copen')
      end
      show_location(items[1])
    end

    local function luals_unique_definition() return vim.lsp.buf.definition({ on_list = on_list }) end

    -- Override global "Go to source" mapping with dedicated buffer-local
    vim.keymap.set('n', 'gd', luals_unique_definition, { buffer = buf_id, desc = 'Lua source definition' })
  end,
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
      diagnostics = {
        -- Don't analyze whole workspace, as it consumes too much CPU and RAM
        workspaceDelay = -1,
      },
      completion = { callSnippet = 'Disable' },
      format = { enable = false },
      hint = { enable = false },
      workspace = {
        checkThirdParty = false,
        ignoreSubmodules = true,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
        },
      },
      telemetry = { enable = false },
    },
  },
}
