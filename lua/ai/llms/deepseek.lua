local helpers = require 'ai.helpers'
local retrieve_llm_key = helpers.retrieve_llm_key

return {
  name = 'deepseek',
  metadata = {
    console = 'https://platform.deepseek.com/usage',
    model_list = 'https://api-docs.deepseek.com/quick_start/pricing',
  },
  adapter = function()
    return require('codecompanion.adapters').extend('deepseek', {
      env = {
        api_key = retrieve_llm_key 'DEEPSEEK_API_KEY',
      },
      schema = {
        model = {
          default = 'deepseek-chat',
        },
      },
    })
  end,
}
