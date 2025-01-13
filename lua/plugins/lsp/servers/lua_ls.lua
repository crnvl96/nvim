return {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then return end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      diagnostics = {
        globals = {
          'vim',
          'MiniPick',
          'MiniClue',
          'MiniDeps',
          'MiniNotify',
          'MiniIcons',
        },
      },
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
        },
      },
    })
  end,
  settings = {
    Lua = {
      format = { enable = false },
      hint = {
        enable = true,
        arrayIndex = 'Disable',
      },
      completion = {
        callSnippet = 'Disable',
        keywordSnippet = 'Disable',
      },
    },
  },
}
