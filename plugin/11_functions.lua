_G.Config = {}
local H = {}

Config.Set = vim.keymap.set

function Config.extend(b, n)
  local base = vim.deepcopy(b or {})
  local new = vim.deepcopy(n or {})
  if H.is_array(base) and H.is_array(new) then return vim.list_extend(base, new) end
  return H.merge(base, new)
end

function Config.S(lhs, rhs, opts, mode)
  lhs = '<Leader>' .. lhs
  rhs = '<Cmd>' .. rhs .. '<CR>'
  mode = mode or 'n'
  Config.Set(mode, lhs, rhs, type(opts) == 'string' and { desc = opts } or opts)
end

function Config.SM(lhs, rhs, opts, mode)
  lhs = '<Leader>' .. lhs
  mode = mode or 'n'

  local new_rhs = function()
    vim.cmd("normal! m'")
    vim.cmd(rhs)
  end

  Config.Set(mode, lhs, new_rhs, type(opts) == 'string' and { desc = opts } or opts)
end

function Config.LS(bufnr, lhs, rhs, desc, mode)
  lhs = '<Leader>' .. lhs
  rhs = '<Cmd>' .. rhs .. '<CR>'
  mode = mode or 'n'
  Config.Set(mode, lhs, rhs, { desc = desc, buffer = bufnr })
end

function Config.LSM(bufnr, lhs, rhs, desc, mode)
  lhs = '<Leader>' .. lhs
  mode = mode or 'n'

  new_rhs = function()
    vim.cmd("normal! m'")
    vim.cmd(rhs)
  end

  Config.Set(mode, lhs, new_rhs, { desc = desc, buffer = bufnr })
end

function Config.toggle_quickfix()
  local quickfix_wins = vim.tbl_filter(
    function(win_id) return vim.fn.getwininfo(win_id)[1].quickfix == 1 end,
    vim.api.nvim_tabpage_list_wins(0)
  )

  local command = #quickfix_wins == 0 and 'copen' or 'cclose'
  vim.cmd(command)
end

function Config.on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  Config.on_attach_maps(bufnr)
end

function Config.build(params, build_cmd)
  vim.notify('Building ' .. params.name, vim.log.levels.INFO)
  local obj = vim.system(build_cmd, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building ' .. params.name .. ' done', vim.log.levels.INFO)
  else
    vim.notify('Building ' .. params.name .. ' failed', vim.log.levels.ERROR)
  end
end

--- Checks if a lua table is an array or not
---@param t table
---@return boolean
function H.is_array(t)
  for i, _ in pairs(t) do
    if type(i) ~= 'number' then return false end
  end

  return true
end

function H.merge(dest, src)
  for k, v in pairs(src) do
    local tgt = rawget(dest, k)

    if type(v) == 'table' and type(tgt) == 'table' then
      if H.is_array(v) and H.is_array(tgt) then
        dest[k] = vim.list_extend(vim.deepcopy(tgt), v)
      else
        H.merge(tgt, v)
      end
    else
      dest[k] = vim.deepcopy(v)
    end
  end

  return dest
end
