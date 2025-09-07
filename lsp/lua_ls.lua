return {
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      completion = { callSnippet = 'Disable' },
      format = { enable = false },
      hint = { enable = false },
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
        },
      },
    },
  },
}
