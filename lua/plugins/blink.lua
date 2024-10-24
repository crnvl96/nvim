return {
  'Saghen/blink.cmp',
  event = 'InsertEnter',
  build = 'cargo build --release',
  opts = {
    sources = {
      completion = {
        enabled_providers = {
          'lsp',
          'path',
        },
      },
    },
    signature = { enabled = true },
  },
}
