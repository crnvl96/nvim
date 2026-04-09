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

function Config.grep_blines()
  local file = vim.fn.getreg('%')
  local left = vim.api.nvim_replace_termcodes('<Left>', true, false, true)
  vim.api.nvim_feedkeys(":sil grep '' -g=" .. file .. string.rep(left, 5 + #file), 'n', false)
end

function Config.grep_blines_fzf()
  local opts = {
    winopts = {
      height = 0.6,
      width = 0.5,
      preview = { vertical = 'up:70%' },
      -- Disable Treesitter highlighting for the matches.
      treesitter = {
        enabled = false,
        fzf_colors = { ['fg'] = { 'fg', 'CursorLine' }, ['bg'] = { 'bg', 'Normal' } },
      },
    },
    fzf_opts = {
      ['--layout'] = 'reverse',
    },
  }
  -- Use grep when in normal mode and blines in visual mode since the former doesn't support
  -- searching inside visual selections.
  -- See https://github.com/ibhagwan/fzf-lua/issues/2051
  local mode = vim.api.nvim_get_mode().mode
  if vim.startswith(mode, 'n') then
    require('fzf-lua').lgrep_curbuf(opts)
  else
    require('fzf-lua').blines(opts)
  end
end

function Config.file_completion_fzf()
  require('fzf-lua').complete_path({
    winopts = {
      height = 0.4,
      width = 0.5,
      relative = 'cursor',
    },
  })
end
