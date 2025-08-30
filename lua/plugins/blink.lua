local b = require('utils.builtin')

require('blink.cmp').setup({
  completion = {
    list = {
      selection = { preselect = false, auto_insert = true },
      max_items = 10,
    },
    documentation = {
      auto_show = true,
    },
    menu = {
      draw = {
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', 'source_name', gap = 1 },
        },
        components = {
          kind_icon = {
            text = function(ctx)
              if ctx.source_id == 'cmdline' then return end
              return ctx.kind_icon .. ctx.icon_gap
            end,
          },
          source_name = {
            text = function(ctx)
              if ctx.source_id == 'cmdline' then return end
              return ctx.source_name:sub(1, 4)
            end,
          },
        },
      },
    },
  },
  cmdline = {
    enabled = false,
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
})

for _, hl in ipairs({
  'BlinkCmpMenu',
  'BlinkCmpMenuBorder',
  'BlinkCmpMenuSelection',
  'BlinkCmpScrollBarThumb',
  'BlinkCmpScrollBarGutter',
  'BlinkCmpLabel',
  'BlinkCmpLabelDeprecated',
  'BlinkCmpLabelMatch',
  'BlinkCmpLabelDetail',
  'BlinkCmpLabelDescription',
  'BlinkCmpKind',
  'BlinkCmpKind',
  'BlinkCmpSource',
  'BlinkCmpGhostText',
  'BlinkCmpDoc',
  'BlinkCmpDocBorder',
  'BlinkCmpDocSeparator',
  'BlinkCmpDocCursorLine',
  'BlinkCmpSignatureHelp',
  'BlinkCmpSignatureHelpBorder',
  'BlinkCmpSignatureHelpActiveParameter',
}) do
  b.override_highlight(hl, { bg = 'none' })
end
