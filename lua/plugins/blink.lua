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
          'buffer',
        },
      },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono',
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        border = 'double',
        draw = {
          treesitter = true,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = 'double',
        },
      },
      ghost_text = {
        enabled = false,
      },
    },
    signature = {
      enabled = true,
      window = {
        border = 'double',
      },
    },
  },
}
