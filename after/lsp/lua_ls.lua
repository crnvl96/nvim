---@type vim.lsp.Config
return {
  ---@diagnostic disable-next-line: unused-local
  on_attach = function(client, buf_id)
    local cmp_provider = client.server_capabilities.completionProvider
    local triggers = { '.', ':', '#', '(' }
    cmp_provider.triggerCharacters = triggers
  end,
  settings = {
    Lua = {
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
