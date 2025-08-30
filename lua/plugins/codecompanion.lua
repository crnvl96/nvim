local f = require('utils.fs')
local bind = require('utils.bind')

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
            GEMINI_API_KEY = f.retrieve_from_env('GEMINI_API_KEY'),
          },
        })
      end,
    },
    http = {
      tavily = function()
        return require('codecompanion.adapters').extend('tavily', {
          env = {
            TAVILY_API_KEY = f.retrieve_from_env('TAVILY_API_KEY'),
          },
        })
      end,
    },
  },
})

bind.map('<Leader>ca', ':CodeCompanionActions<cr>', 'Codecompanion Actions', { 'n', 'v' })
bind.map('<Leader>cc', ':CodeCompanionChat Toggle<cr>', 'Codecompanion Toggle Chat', { 'n', 'v' })
bind.xmap('ga', ':CodeCompanionChat Add<cr>', 'Add to Codecompanion Chat')
