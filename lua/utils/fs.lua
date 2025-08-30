---@class Utils.Fs
local M = {}

--- Retrieve values of environment variables.
--- These variables must be stored at a .env file, at the root of the neovim config folder
---@param key_name string Name of the variable to be retrieved
---@return string|nil
function M.retrieve_from_env(key_name)
  local home = os.getenv('HOME')
  local filepath = home .. '/.config/nvim/.env'
  local file = io.open(filepath, 'r')
  if not file then return nil end
  for line in file:lines() do
    line = line:match('^%s*(.-)%s*$')
    if line ~= '' and not line:match('^#') then
      local eq_pos = line:find('=')
      if eq_pos then
        local current_key = line:sub(1, eq_pos - 1)
        local current_value = line:sub(eq_pos + 1)
        current_key = current_key:match('^%s*(.-)%s*$')
        current_value = current_value:match('^%s*(.-)%s*$')
        if current_key == key_name then
          file:close()
          return current_value
        end
      end
    end
  end
  file:close()
  return nil
end

return M
