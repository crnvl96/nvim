Add('olimorris/codecompanion.nvim')

local path = vim.fn.stdpath('config') .. '/anthropic'
local file = io.open(path, 'r')
local key

if file then
  key = file:read('*a'):gsub('%s+$', '')
  file:close()
end

require('codecompanion').setup({
  strategies = {
    chat = { adapter = 'anthropic' },
    inline = { adapter = 'anthropic' },
    cmd = { adapter = 'anthropic' },
  },
  adapters = {
    anthropic = require('codecompanion.adapters').extend('anthropic', {
      env = { api_key = key },
      schema = {
        model = {
          default = 'claude-3-5-haiku-20241022',
        },
      },
    }),
  },
})
