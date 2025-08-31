local U = require('utils')

require('blink.cmp').setup({
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
    documentation = { auto_show = true },
    cmdline = { enabled = false },
    menu = {
      scrollbar = false,
      draw = {
        components = {
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
})

for _, hl in ipairs({ 'Pmenu' }) do
  U.override_highlight(hl, { bg = 'none' })
end
