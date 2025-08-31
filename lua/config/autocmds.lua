local U = require('utils')

--- Check if a window is a float window
---@param winnr integer Window ID to be checked
---@return boolean
local function win_is_float(winnr)
  local wincfg = vim.api.nvim_win_get_config(winnr)
  if wincfg and (wincfg.external or wincfg.relative and #wincfg.relative > 0) then return true end
  return false
end

U.augroup('crnvl96-yank-hl', function(g)
  U.aucmd('TextYankPost', {
    group = g,
    callback = function()
      vim.hl.on_yank({
        priority = 250,
        higroup = 'IncSearch',
        timeout = 150,
      })
    end,
  })
end)

U.augroup('crnvl96-last-location', function(g)
  U.aucmd('BufReadPost', {
    group = g,
    callback = function(e)
      local mark = vim.api.nvim_buf_get_mark(e.buf, '"')
      local line_count = vim.api.nvim_buf_line_count(e.buf)
      if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
    end,
  })
end)

U.augroup(
  'crnvl96-termoptions',
  function(g)
    U.aucmd('TermOpen', {
      group = g,
      command = 'setlocal listchars= nonumber norelativenumber',
    })
  end
)

U.augroup(
  'crnvl96-resize-windows',
  function(g)
    U.aucmd('VimResized', {
      group = g,
      command = 'tabdo wincmd =',
    })
  end
)

-- https://vim.fandom.com/wiki/Avoid_scrolling_when_switch_buffers
U.augroup('crnvl96-do-not-autoscroll', function(g)
  U.aucmd('BufLeave', {
    group = g,
    desc = 'Avoid autoscroll when switching buffers',
    callback = function()
      -- at this stage, current buffer is the buffer we leave
      -- but the current window already changed, verify neither
      -- source nor destination are floating windows
      local from_buf = vim.api.nvim_get_current_buf()
      local from_win = vim.fn.bufwinid(from_buf)
      local to_win = vim.api.nvim_get_current_win()
      if not win_is_float(to_win) and not win_is_float(from_win) then vim.b.__VIEWSTATE = vim.fn.winsaveview() end
    end,
  })
  U.aucmd('BufEnter', {
    group = g,
    desc = 'Avoid autoscroll when switching buffers',
    callback = function()
      if vim.b.__VIEWSTATE then
        local to_win = vim.api.nvim_get_current_win()
        if not win_is_float(to_win) then vim.fn.winrestview(vim.b.__VIEWSTATE) end
        vim.b.__VIEWSTATE = nil
      end
    end,
  })
end)
