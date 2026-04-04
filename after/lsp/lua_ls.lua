---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  ---@diagnostic disable-next-line: unused-local
  on_attach = function(client, buf_id)
    local cmp_provider = client.server_capabilities.completionProvider
    local triggers = { '.', ':', '#', '(' }
    cmp_provider.triggerCharacters = triggers
  end,
  root_markers = {
    {
      '.emmyrc.json',
      '.luarc.json',
      '.luarc.jsonc',
    },
    {
      '.luacheckrc',
      '.stylua.toml',
      'stylua.toml',
      'selene.toml',
      'selene.yml',
    },
    {
      '.git',
    },
  },
  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {
      codeLens = {
        enable = false,
      },
      hint = {
        enable = false,
        semicolon = 'Disable',
      },
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      workspace = {
        ignoreSubmodules = true,
        library = { vim.env.VIMRUNTIME, '${3rd}/luv/library' },
      },
    },
  },
}
