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

MiniDeps.add({
  source = 'Saghen/blink.cmp',
  hooks = {
    post_install = build_cargo,
    post_checkout = build_cargo,
  },
})

require('blink.cmp').setup({
  appearance = { nerd_font_variant = 'mono' },
  keymap = {
    preset = 'default',
    ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings' },
  },
  -- cmdline = {
  --   keymap = { preset = 'inherit' },
  --   completion = {
  --     list = {
  --       selection = {
  --         preselect = false,
  --         auto_insert = true,
  --       },
  --     },
  --     menu = { auto_show = true },
  --     ghost_text = { enabled = true },
  --   },
  -- },
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

vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })

for _, hl in ipairs({ 'Pmenu', 'StatusLine', 'StatusLineNC', 'StatusLineTerm', 'StatusLineTermNC' }) do
  local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl, link = false })
  if is_ok then
    vim.api.nvim_set_hl(0, hl, vim.tbl_deep_extend('force', hl_def --[[@as vim.api.keyset.highlight]], { bg = 'none' }))
  end
end

MiniDeps.add({ source = 'stevearc/conform.nvim' })

vim.g.autoformat = true
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup({
  notify_on_error = true,
  format_on_save = function()
    if not vim.g.autoformat then return nil end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  formatters = { prettier = { require_cwd = true } },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    javascript = { 'prettier', name = 'dprint' },
    javascriptreact = { 'prettier', name = 'dprint' },
    typescript = { 'prettier', name = 'dprint' },
    typescriptreact = { 'prettier', name = 'dprint' },
    json = { name = 'dprint' },
    jsonc = { name = 'dprint' },
    lua = { 'stylua' },
    markdown = { name = 'dprint' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format', name = 'dprint' },
    rust = { lsp_format = 'prefer' },
    go = { lsp_format = 'prefer' },
    toml = { name = 'dprint' },
    yaml = { lsp_format = 'prefer' },
  },
})

vim.api.nvim_create_user_command('PluginToggleFormat', function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(('%s formatting...'):format(vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
end, { nargs = 0 })
