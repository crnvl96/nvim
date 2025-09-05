local minipath = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

--- Open MiniFiles at the current directory
---@return nil
local function open_file_explorer()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')
  if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
end

if not vim.loop.fs_stat(minipath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    minipath,
  })
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup()

MiniDeps.add({ name = 'mini.nvim' })

local hues, colors = require('mini.hues'), require('mini.colors')
hues.apply_palette(hues.make_palette({
  background = vim.o.background == 'dark' and '#212223' or '#e1e2e3',
  foreground = vim.o.background == 'dark' and '#d5d4d3' or '#2f2e2d',
  saturation = vim.o.background == 'dark' and 'lowmedium' or 'mediumhigh',
  accent = 'bg',
}))

colors
  .get_colorscheme()
  :add_terminal_colors()
  :add_cterm_attributes()
  :add_transparency({
    float = true,
    statuscolumn = true,
    statusline = false,
    tabline = true,
    winbar = true,
  })
  :apply()

for _, hl in ipairs({
  'MiniFilesBorder',
  'MiniFilesBorderModified',
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
}) do
  local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl, link = false })
  if is_ok then
    vim.api.nvim_set_hl(0, hl, vim.tbl_deep_extend('force', hl_def --[[@as vim.api.keyset.highlight]], { bg = 'none' }))
  end
end

require('mini.doc').setup()
require('mini.icons').setup()
require('mini.misc').setup()
require('mini.extra').setup()
require('mini.keymap').setup()
require('mini.align').setup()

require('mini.ai').setup({
  custom_textobjects = {
    B = MiniExtra.gen_ai_spec.buffer(),
    F = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
  },
  silent = true,
  search_method = 'cover',
  mappings = {
    around_next = '',
    inside_next = '',
    around_last = '',
    inside_last = '',
  },
})

require('mini.files').setup({
  mappings = {
    show_help = '?',
    go_in = '',
    go_out = '',
    go_in_plus = '<CR>',
    go_out_plus = '-',
  },
})

vim.keymap.set('n', '-', open_file_explorer)

require('mini.keymap').map_multistep({ 'i', 'c' }, '<C-n>', { 'blink_next', 'pmenu_next' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<C-p>', { 'blink_prev', 'pmenu_prev' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<Tab>', { 'blink_next', 'pmenu_next' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<S-Tab>', { 'blink_prev', 'pmenu_prev' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<CR>', { 'blink_accept', 'pmenu_accept' })
require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')
require('mini.keymap').map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
require('mini.keymap').map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
