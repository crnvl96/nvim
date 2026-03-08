require('mini.bufremove').setup()

local function wipeout_all_buffers()
  local current_buffer = vim.api.nvim_get_current_buf()
  vim
    .iter(vim.api.nvim_list_bufs())
    :filter(function(bufnr) return bufnr ~= current_buffer end)
    :each(function(bufnr) MiniBufremove.wipeout(bufnr, true) end)
end

vim.keymap.set('n', '<Leader>uo', wipeout_all_buffers, { desc = 'Wipeout Other Buffers' })
