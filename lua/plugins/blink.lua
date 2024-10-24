return {
  -- This plugin is required by other sorces, such as lsp providers
  --
  -- So, we do not need to explicitily load it
  'Saghen/blink.cmp',
  -- The backend of this plugin is written in rust. So we need to build it every time
  build = 'cargo build --release',
  opts = {
    sources = {
      default = {
        'lsp',
        'path',
      },
    },
    -- allows support for signature-help
    signature = {
      enabled = true,
    },
  },
}
