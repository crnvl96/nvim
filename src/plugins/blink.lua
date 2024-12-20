local function build_blink(params)
  vim.notify('Building blink.cmp', vim.log.levels.INFO)
  local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building blink.cmp done', vim.log.levels.INFO)
  else
    vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
  end
end

Add('saghen/blink.compat')
Add({
  source = 'Saghen/blink.cmp',
  hooks = {
    post_install = build_blink,
    post_checkout = build_blink,
  },
})

require('blink.compat').setup()

require('blink.cmp').setup({
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
})
