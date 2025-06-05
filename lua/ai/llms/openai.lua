local helpers = require 'ai.helpers'
local retrieve_llm_key = helpers.retrieve_llm_key

return {
  name = 'openai',
  metadata = {
    console = 'https://platform.openai.com/settings/organization/api-keys',
    model_list = 'https://platform.openai.com/docs/models',
  },
  adapter = function()
    return require('codecompanion.adapters').extend('openai', {
      env = { api_key = retrieve_llm_key 'OPENAI_API_KEY' },
      schema = { model = { default = 'gpt-4.1' } },
    })
  end,
}
