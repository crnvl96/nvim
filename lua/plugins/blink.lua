return {
  'saghen/blink.cmp',
  build = 'cargo build --release',
  event = 'InsertEnter',
  dependencies = {
    {
      'saghen/blink.compat',
      opts = {},
    },
  },
  opts = {
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono',
    },
    completion = {
      trigger = {
        show_on_insert_on_trigger_character = false,
      },
      accept = {
        auto_brackets = { enabled = false },
      },
      menu = {
        draw = {
          treesitter = { 'lsp' },
        },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      ghost_text = { enabled = false },
    },
    signature = { enabled = true },
    sources = {
      cmdline = {},
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      per_filetype = {
        codecompanion = { 'codecompanion', 'path' },
      },
      providers = {
        codecompanion = {
          name = 'CodeCompanion',
          module = 'codecompanion.providers.completion.blink',
          enabled = true,
        },
      },
    },
  },
}
