_G.Config = {}

Config.build = function(params, cmd)
  local notif = function(msg, lvl) vim.notify(msg, vim.log.levels[lvl]) end
  local pref = 'Building ' .. params.name

  notif(pref, 'INFO')

  local obj = vim.system(cmd, { cwd = params.path }):wait()
  local res = obj.code == 0 and (pref .. ' done') or (pref .. ' failed')
  local lvl = obj.code == 0 and 'INFO' or 'ERROR'

  notif(res, lvl)
end
