local helpers = require 'ai.helpers'
local retrieve_llm_key = helpers.retrieve_llm_key

return {
  name = 'xai',
  metadata = {
    console = 'https://console.x.ai/team/bfc3c115-d34f-4d5c-b52e-9d10a63ecfa8',
    model_list = 'https://console.x.ai/team/bfc3c115-d34f-4d5c-b52e-9d10a63ecfa8/models',
  },
  adapter = function()
    return require('codecompanion.adapters').extend('xai', {
      env = {
        api_key = retrieve_llm_key 'XAI_API_KEY',
      },
      schema = {
        model = {
          default = 'grok-3',
        },
      },
    })
  end,
}
