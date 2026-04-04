local function goto_hunk()
  local file

  -- Find the file from the +++ header above
  for i = vim.fn.line('.'), 1, -1 do
    local l = vim.fn.getline(i)
    local f = l:match('^%+%+%+ (.+)$')
    if f then
      file = f
      break
    end
  end

  if not file then return end

  -- Find the hunk header @@ and parse the +line number
  for i = vim.fn.line('.'), 1, -1 do
    local l = vim.fn.getline(i)
    local start = l:match('^@@ .* %+(%d+)')
    if start then
      local offset = vim.fn.line('.') - i - 1
      vim.cmd('wincmd p')
      vim.cmd('edit ' .. file)
      vim.api.nvim_win_set_cursor(0, { tonumber(start) + math.max(offset, 0), 0 })
      return
    end
  end
end

vim.keymap.set('n', '<CR>', goto_hunk, { desc = 'Goto hunk', buffer = true })
