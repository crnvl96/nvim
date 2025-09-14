--- Open MiniFiles at the current directory
---@return nil
local function open_file_explorer()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')
  if path and vim.uv.fs_stat(path) then MiniFiles.open(bufname, false) end
end

local minipath = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
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

local palette = require('mini.hues').make_palette({
  background = vim.o.background == 'dark' and '#212223' or '#e1e2e3',
  foreground = vim.o.background == 'dark' and '#d5d4d3' or '#2f2e2d',
  saturation = vim.o.background == 'dark' and 'lowmedium' or 'mediumhigh',
  accent = 'bg',
})

require('mini.hues').apply_palette(palette)

require('mini.colors')
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
  'Pmenu',
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
    if hl == 'Pmenu' then
      vim.api.nvim_set_hl(
        0,
        hl,
        vim.tbl_deep_extend('force', hl_def --[[@as vim.api.keyset.highlight]], { bg = 'none' })
      )
    else
      vim.api.nvim_set_hl(
        0,
        hl,
        vim.tbl_deep_extend('force', hl_def --[[@as vim.api.keyset.highlight]], { bg = 'none' })
      )
    end
  end
end

require('mini.doc').setup()
require('mini.icons').setup()
require('mini.misc').setup()
require('mini.extra').setup()
require('mini.keymap').setup()
require('mini.align').setup()
require('mini.splitjoin').setup()
require('mini.extra').setup()
require('mini.pick').setup()

require('mini.files').setup({
  mappings = {
    show_help = '?',
    go_in = '',
    go_out = '',
    go_in_plus = '<CR>',
    go_out_plus = '-',
  },
})

MiniKeymap.map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
MiniKeymap.map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')

vim.ui.select = require('mini.pick').ui_select

vim.keymap.set('n', '<Leader>f', '<Cmd>Pick files<CR>')
vim.keymap.set('n', '<Leader>g', '<Cmd>Pick grep_live<CR>')
vim.keymap.set('n', '<Leader>l', '<Cmd>Pick buf_lines scope="current"<CR>')
vim.keymap.set('n', '<Leader>b', '<Cmd>Pick buffers include_current=false<CR>')
vim.keymap.set('n', '-', open_file_explorer)
