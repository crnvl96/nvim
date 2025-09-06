require('blink.cmp').setup({
  appearance = { nerd_font_variant = 'mono' },
  keymap = {
    preset = 'default',
    ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings' },
  },
  cmdline = {
    keymap = { preset = 'inherit' },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
      menu = { auto_show = true },
      ghost_text = { enabled = true },
    },
  },
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
    documentation = { auto_show = true },
    menu = {
      scrollbar = false,
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
})

for _, hl in ipairs({ 'Pmenu', 'StatusLine', 'StatusLineNC', 'StatusLineTerm', 'StatusLineTermNC' }) do
  local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl, link = false })
  if is_ok then
    vim.api.nvim_set_hl(0, hl, vim.tbl_deep_extend('force', hl_def --[[@as vim.api.keyset.highlight]], { bg = 'none' }))
  end
end
