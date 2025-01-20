_G.Utils = {}

Utils.Autocmd = vim.api.nvim_create_autocmd

Utils.Keymap2 = function(desc, opts)
  opts = opts or {}
  opts.desc = desc

  local lhs = ''
  local rhs = ''
  local mode = 'n'

  if opts.mode then
    mode = opts.mode
    opts.mode = nil
  end

  if opts.lhs then
    lhs = opts.lhs
    opts.lhs = nil
  end

  if opts.rhs then
    rhs = opts.rhs
    opts.rhs = nil
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

Utils.Group = function(name, fn) fn(vim.api.nvim_create_augroup(name, { clear = true })) end

Utils.Log = function(msg, code)
  local lvls = { 'INFO', 'WARN', 'ERROR' }
  local lvl = lvls[code]

  vim.notify(msg, vim.log.levels[lvl])
end

Utils.Req = function(tool)
  if vim.fn.executable(tool) ~= 1 then Utils.Log(tool .. ' is not installed in the system!', 3) end
end

Utils.Build = function(params, cmd)
  local pref = 'Building ' .. params.name
  Utils.Log(pref, 1)

  local obj = vim.system(cmd, { cwd = params.path }):wait()
  local res = obj.code == 0 and (pref .. ' done') or (pref .. ' failed')
  local lvl = obj.code == 0 and 1 or 3

  Utils.Log(res, lvl)
end
