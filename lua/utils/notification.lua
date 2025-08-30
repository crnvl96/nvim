---@class Utils.Notification
local M = {}

--- A small wrapper that auto handles the cleaning of published notifications
---@param msg string Msg to be published
---@param lvl? string Lvl of the publication. Defaults to INFO
---@return nil
function M.publish(msg, lvl)
  local durations = {
    ERROR = 3000,
    WARN = 2000,
    INFO = 2000,
    DEBUG = 0,
    TRACE = 0,
    OFF = 0,
  }

  lvl = lvl or 'INFO'
  local id = MiniNotify.add(msg, lvl)
  local function clear() MiniNotify.remove(id) end
  vim.defer_fn(clear, durations[lvl])
end

return M
