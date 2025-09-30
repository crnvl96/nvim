local minipath = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(minipath) then
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

require('mini.misc').setup()

require('mini.pick').setup({
  window = {
    config = function()
      local height = math.floor(0.618 * vim.o.lines)
      local width = math.floor(0.618 * vim.o.columns)
      return {
        anchor = 'NW',
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      }
    end,
  },
  source = {
    show = require('mini.pick').default_show,
  },
})

vim.keymap.set('n', '<Leader>f', '<Cmd>Pick files<CR>')
vim.keymap.set('n', '<Leader>g', '<Cmd>Pick grep_live<CR>')
vim.keymap.set('n', '<Leader>b', '<Cmd>Pick buffers include_current=false<CR>')
vim.keymap.set('n', '<Leader>l', '<Cmd>Pick buf_lines scope="current"<CR>')

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  local start_opts = { window = { config = { width = vim.o.columns } } }
  return MiniPick.ui_select(items, opts, on_choice, start_opts)
end

require('mini.files').setup({
  content = {
    prefix = function() end,
  },
  mappings = {
    show_help = '?',
    go_in = '',
    go_out = '',
    go_in_plus = '<CR>',
    go_out_plus = '-',
  },
})

--- Open MiniFiles at the current directory
local function open_file_explorer()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')
  if path and vim.uv.fs_stat(path) then MiniFiles.open(bufname, false) end
end

vim.keymap.set('n', '-', function() return open_file_explorer() end)
