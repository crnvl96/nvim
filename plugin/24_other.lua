--- Auto format using conform.nvim
local function format_current() require('conform').format({ bufnr = vim.api.nvim_get_current_buf() }) end

--- Toggle auto format on save
local function toggle_autoformat()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(('%s formatting...'):format(vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
end

vim.g.gruvbox_material_enable_italic = true
vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_enable_bold = true
vim.g.gruvbox_material_transparent_background = 2
vim.g.gruvbox_material_ui_contrast = 'high'
vim.g.gruvbox_material_float_style = 'none'

vim.cmd.colorscheme('gruvbox-material')

local function mod_hl(hl_name, opts)
  local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl_name, link = false })
  if is_ok then
    for k, v in pairs(opts) do
      hl_def[k] = v
    end
    vim.api.nvim_set_hl(0, hl_name, hl_def --[[@as vim.api.keyset.highlight]])
  end
end

for _, hl in ipairs({
  'MiniFilesBorder',
  'MiniFilesBorderModified',
  'MiniFilesCursorLine',
  'MiniFilesDirectory',
  'MiniFilesFile',
  'MiniFilesNormal',
  'MiniFilesTitle',
  'MiniFilesTitleFocused',
  'MiniPickBorder',
  'MiniPickBorderBusy',
  'MiniPickBorderText',
  'MiniPickCursor',
  'MiniPickIconDirectory',
  'MiniPickIconFile',
  'MiniPickHeader',
  'MiniPickNormal',
  'MiniPickPreviewLine',
  'MiniPickPreviewRegion',
  'MiniPickPrompt',
  'MiniPickPromptCaret',
  'MiniPickPromptPrefix',
  'Pmenu',
  'PmenuThumb',
  'PmenuSbar',
  'PmenuExtra',
  'PmenuKind',
  'NonText',
  'NormalFloat',
  'LspSignatureActiveParameter',
}) do
  mod_hl(hl, { bg = 'none' })
end

vim.g.autoformat = true
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup({
  notify_on_error = true,
  format_on_save = function()
    if not vim.g.autoformat then return nil end
    return {
      timeout_ms = 500,
      lsp_format = 'fallback',
    }
  end,
  formatters = {
    prettier = {
      require_cwd = true,
    },
  },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    javascript = { 'prettier', name = 'dprint' },
    javascriptreact = { 'prettier', name = 'dprint' },
    typescript = { 'prettier', name = 'dprint' },
    typescriptreact = { 'prettier', name = 'dprint' },
    json = { name = 'dprint' },
    jsonc = { name = 'dprint' },
    lua = { name = 'stylua' },
    markdown = { name = 'dprint' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format', name = 'dprint' },
    rust = { lsp_format = 'prefer' },
    go = { lsp_format = 'prefer' },
    toml = { name = 'dprint' },
    yaml = { lsp_format = 'prefer' },
  },
})

vim.api.nvim_create_user_command('Fmt', format_current, { nargs = 0 })
vim.api.nvim_create_user_command('ToggleFmt', toggle_autoformat, { nargs = 0 })
