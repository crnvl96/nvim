---Debounce func on trailing edge.
---@generic F: function
---@param func F
---@param delay_ms number
---@return F
Config.debounce = function(func, delay_ms)
  ---@type uv.uv_timer_t?
  local timer = nil
  ---@type boolean?
  local running = nil
  return function(...)
    if not running then timer = assert(vim.uv.new_timer()) end
    local argv = { ... }
    assert(timer):start(delay_ms, 0, function()
      assert(timer):stop()
      running = nil
      func(unpack(argv, 1, table.maxn(argv)))
    end)
  end
end

--- Toggle diagnostic for current buffer
---@return string String indicator for new state. Similar to what |:set| `{option}?` shows.
Config.toggle_diagnostic = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local is_enabled = vim.diagnostic.is_enabled({ bufnr = buf_id })
  vim.diagnostic.enable(not is_enabled, { bufnr = buf_id })
  local new_buf_state = not is_enabled
  return new_buf_state and '  diagnostic' or 'nodiagnostic'
end
