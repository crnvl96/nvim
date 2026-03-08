require('mini.files').setup({
  mappings = {
    go_in = '',
    go_in_plus = '<CR>',
    go_out = '',
    go_out_plus = '-',
  },
  windows = {
    max_number = 1,
    preview = false,
    width_focus = math.floor(vim.o.columns * 1),
    width_nofocus = math.floor(vim.o.columns * 0.59),
    width_preview = math.floor(vim.o.columns * 0.59),
  },
})

local filter_show = function() return true end
local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, '.') end

local show_dotfiles = true
local show_preview = false

local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
end

local toggle_preview = function()
  show_preview = not show_preview
  MiniFiles.refresh({
    windows = {
      max_number = show_preview and 2 or 1,
      preview = show_preview and true or false,
      width_focus = math.floor(vim.o.columns * (show_preview and 0.39 or 1)),
    },
  })
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(e)
    local buf_id = e.data.buf_id
    vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
    vim.keymap.set('n', 'gp', toggle_preview, { buffer = buf_id })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesExplorerClose',
  group = Config.gr,
  callback = function()
    show_dotfiles = true
    show_preview = false
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesExplorerOpen',
  group = Config.gr,
  callback = function()
    MiniFiles.set_bookmark('_', vim.fn.getcwd(), { desc = 'Working directory' })
    MiniFiles.set_bookmark('@', vim.env.HOME .. '/Developer', { desc = 'Projects' })
    MiniFiles.set_bookmark('.', vim.env.HOME, { desc = 'Home directory' })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesWindowUpdate',
  callback = function(e)
    local config = vim.api.nvim_win_get_config(e.data.win_id)
    config.height = vim.o.lines
  end,
})

local function open_explorer_here()
  local file = vim.api.nvim_buf_get_name(0)
  MiniFiles.open(file, false)
end

vim.keymap.set('n', '<Leader>ef', open_explorer_here, { desc = 'Explorer' })
