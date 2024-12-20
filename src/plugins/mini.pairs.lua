Snacks.toggle({
  name = 'mini pairs',
  get = function() return not vim.g.minipairs_disable end,
  set = function(state) vim.g.minipairs_disable = not state end,
}):map('<leader>up', { desc = 'toggle: mini.pairs' })

local skip_next = [=[[%w%%%'%[%"%.%`%$]]=] -- skip autopair when next character is one of these
local skip_ts = { 'string' } -- skip autopair when the cursor is inside these treesitter nodes

require('mini.pairs').setup({ insert = true, command = true, terminal = false })

local open = require('mini.pairs').open
require('mini.pairs').open = function(pair, neigh_pattern)
  if vim.fn.getcmdline() ~= '' then return open(pair, neigh_pattern) end
  local o, c = pair:sub(1, 1), pair:sub(2, 2)
  local line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local next = line:sub(cursor[2] + 1, cursor[2] + 1)
  local before = line:sub(1, cursor[2])
  if o == '`' and vim.bo.filetype == 'markdown' and before:match('^%s*``') then
    return '`\n```' .. vim.api.nvim_replace_termcodes('<up>', true, true, true)
  end
  if skip_next and next ~= '' and next:match(skip_next) then return o end
  if skip_ts and #skip_ts > 0 then
    local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
    for _, capture in ipairs(ok and captures or {}) do
      if vim.tbl_contains(skip_ts, capture.capture) then return o end
    end
  end
  if next == c and c ~= o then
    local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), '')
    local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), '')
    if count_close > count_open then return o end
  end
  return open(pair, neigh_pattern)
end
