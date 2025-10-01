require('mini.icons').setup()
require('mini.misc').setup()
require('mini.align').setup()
require('mini.splitjoin').setup()
require('mini.extra').setup()
require('mini.git').setup()
require('mini.diff').setup({ view = { style = 'sign' } })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'diff', 'git', 'gitcommit', 'gitrebase' },
  command = 'setlocal foldmethod=expr foldexpr=v:lua.MiniGit.diff_foldexpr()',
})

require('mini.pick').setup()

vim.keymap.set('n', '<Leader>f', '<Cmd>Pick files<CR>')
vim.keymap.set('n', '<Leader>g', '<Cmd>Pick grep_live<CR>')
vim.keymap.set('n', '<Leader>b', '<Cmd>Pick buffers include_current=false<CR>')
vim.keymap.set('n', '<Leader>l', '<Cmd>Pick buf_lines scope="current"<CR>')
vim.keymap.set('n', '<Leader>o', '<Cmd>lua MiniDiff.toggle_overlay()<CR>')

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  local start_opts = { window = { config = { width = vim.o.columns } } }
  return MiniPick.ui_select(items, opts, on_choice, start_opts)
end

require('mini.files').setup({
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
