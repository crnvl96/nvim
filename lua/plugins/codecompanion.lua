local U = require('utils')

--- Retrieve values of environment variables.
--- These variables must be stored at a .env file, at the root of the neovim config folder
---@param key_name string Name of the variable to be retrieved
---@return string|nil
local function retrieve_from_env(key_name)
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

require('codecompanion').setup({
  strategies = {
    chat = {
      adapter = 'gemini_cli',
    },
    inline = {
      adapter = 'gemini_cli',
    },
    cmd = {
      adapter = 'gemini_cli',
    },
  },
  adapters = {
    acp = {
      gemini_cli = function()
        return require('codecompanion.adapters').extend('gemini_cli', {
          defaults = {
            mcpServers = {},
          },
          env = {
            GEMINI_API_KEY = retrieve_from_env('GEMINI_API_KEY'),
          },
        })
      end,
    },
    http = {
      tavily = function()
        return require('codecompanion.adapters').extend('tavily', {
          env = {
            TAVILY_API_KEY = retrieve_from_env('TAVILY_API_KEY'),
          },
        })
      end,
    },
  },
})

U.map('<Leader>ca', ':CodeCompanionActions<cr>', 'Codecompanion Actions', { 'n', 'v' })
U.map('<Leader>cc', ':CodeCompanionChat Toggle<cr>', 'Codecompanion Toggle Chat', { 'n', 'v' })
U.xmap('ga', ':CodeCompanionChat Add<cr>', 'Add to Codecompanion Chat')
