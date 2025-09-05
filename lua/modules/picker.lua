local function fuzzy_filter_qf(...)
  local args = { ... }
  local query = table.concat(args, ' ')
  local qf_items = vim.fn.getqflist()
  local filtered = vim.fn.matchfuzzy(qf_items, query, { key = 'text' })
  vim.fn.setqflist(filtered)
end

vim.api.nvim_create_user_command('Zgrep', function(opts)
  local query, path = unpack(vim.split(opts.args, ' '))
  path = path or '.'
  vim.cmd("sil grep! '" .. query .. "' " .. path)
  local sort_query = query:gsub('%.%*', ''):gsub('\\(.)', '%1')
  fuzzy_filter_qf(sort_query)
  vim.cmd('copen')
end, { nargs = '+', complete = 'file_in_path' })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl-quickfix', { clear = true }),
  pattern = 'qf',
  callback = function(e)
    vim.api.nvim_create_user_command('Cfuzzy', function(opts) fuzzy_filter_qf(opts.args) end, { nargs = 1 })
    vim.keymap.set('n', '<M-g>', ':Cfilter<space>', { buffer = e.buf })
    vim.keymap.set('n', '<C-g>', ':Cfuzzy<space>', { buffer = e.buf })
  end,
})

vim.keymap.set('n', '<leader>b', ':b<space>')
vim.keymap.set('n', '<leader>g', ':Zgrep<space>')
