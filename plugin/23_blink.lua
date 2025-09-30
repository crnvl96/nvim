local function build_cargo(p)
  vim.notify('Building ' .. p.name, vim.log.levels.INFO)
  local cmd = { 'cargo', '+nightly', 'build', '--release' }
  local opts = { cwd = p.path }
  local obj = vim.system(cmd, opts):wait()
  if obj.code == 0 then
    vim.notify('Done!', vim.log.levels.INFO)
  else
    vim.notify('A Fail occurred!', vim.log.levels.ERROR)
  end
end

local cargo_hooks = { post_install = build_cargo, post_checkout = build_cargo }
MiniDeps.add({ source = 'Saghen/blink.cmp', hooks = cargo_hooks })

require('blink.cmp').setup({
  appearance = { nerd_font_variant = 'mono' },
  keymap = { preset = 'default', ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings' } },
  cmdline = {
    enabled = true,
    keymap = { preset = 'cmdline' },
    completion = {
      list = { selection = { preselect = false } },
      menu = { auto_show = function() return vim.fn.getcmdtype() == ':' end },
      ghost_text = { enabled = true },
    },
  },
  completion = {
    list = { selection = { preselect = false, auto_insert = true } },
    documentation = { auto_show = true },
    menu = {
      scrollbar = false,
      draw = {
        columns = { { 'kind_icon' }, { 'label', 'label_description', 'source_name', gap = 1 } },
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

vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })
