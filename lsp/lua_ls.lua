return {
  on_init = function(client)
    client.server_capabilities.semanticTokensProvider = nil

    if client.workspace_folders then
      local path = client.workspace_folders[1].name

      if
        path ~= vim.fn.stdpath 'config'
        and (
          vim.loop.fs_stat(path .. '/.luarc.json')
          or vim.loop.fs_stat(path .. '/.luarc.jsonc')
        )
      then
        return
      end
    end

    client.config.settings.Lua =
      vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
          library = {
            '$VIMRUNTIME',
            '$XDG_DATA_HOME/nvim/site/pack/deps/opt',
            '${3rd}/luv/library',
          },
        },
      })
  end,
  settings = {
    Lua = {
      format = { enable = false },
    },
  },
}
