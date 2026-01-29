---@diagnostic disable: undefined-global, unused-local

local ltr = MiniDeps.later

local _has_rg = function() return vim.fn.executable 'rg' == 1 end

local function debounce(func, delay_ms)
  return function(...)
    local timer = vim.uv.new_timer()
    local delay_pre_start = 0
    local argv = { ... }

    delay_ms = delay_ms or 100
    timer = assert(timer)

    local callback = function()
      timer:stop()
      func(unpack(argv))
    end

    timer:start(delay_ms, delay_pre_start, vim.schedule_wrap(callback))
  end
end

local function is_cmdline_type_find()
  local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
  return cmdline_cmd == 'find' or cmdline_cmd == 'fin'
end

local function should_enable_autocomplete()
  local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
  local cmdline_type = vim.fn.getcmdtype()
  return cmdline_type == '/'
    or cmdline_type == '?'
    or (
      cmdline_type == ':'
      and (
        is_cmdline_type_find()
        or cmdline_cmd == 'help'
        or cmdline_cmd == 'h'
        or cmdline_cmd == 'buffer'
        or cmdline_cmd == 'b'
      )
    )
end

local function _find_files_with_rg(cmdarg)
  local fnames = vim.fn.systemlist 'rg --files --hidden --color=never --glob="!.git"'
  return #cmdarg == 0 and fnames or vim.fn.matchfuzzy(fnames, cmdarg)
end

ltr(function()
  if _has_rg() then
    function _G.FindFunc(cmdarg, _cmdcomplete) return _find_files_with_rg(cmdarg) end
    vim.o.findfunc = 'v:lua.FindFunc'
  end

  vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
    group = vim.api.nvim_create_augroup('crnvl96-cmdline-completion', { clear = true }),
    callback = debounce(function(e)
      if e.event == 'CmdlineChanged' and should_enable_autocomplete() then vim.fn.wildtrigger() end
    end),
  })
end)
