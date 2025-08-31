---@brief
---
--- https://taplo.tamasfe.dev/cli/usage/language-server.html
---
--- Language server for Taplo, a TOML toolkit.
---
--- `taplo-cli` can be installed via `cargo`:
--- ```sh
--- cargo install --features lsp --locked taplo-cli
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'taplo', 'lsp', 'stdio' },
  filetypes = { 'toml' },
  root_markers = { '.taplo.toml', 'taplo.toml', '.git' },
  settings = {
    taplo = {
      configFile = { enabled = true },
      schema = {
        enabled = true,
        catalogs = { 'https://www.schemastore.org/api/json/catalog.json' },
        cache = {
          memoryExpiration = 60,
          diskExpiration = 600,
        },
      },
    },
  },
  on_init = function(client)
    --- https://github.com/neovim/nvim-lspconfig/pull/4016
    client.server_capabilities.documentFormattingProvider = false
  end,
}
