local helpers = require 'ai.helpers'
local retrieve_llm_key = helpers.retrieve_llm_key

return {
  name = 'gemini',
  metadata = {
    console = 'https://aistudio.google.com/apikey',
    model_list = 'https://ai.google.dev/gemini-api/docs/models',
  },
  adapter = function()
    return require('codecompanion.adapters').extend('gemini', {
      env = { api_key = retrieve_llm_key 'GEMINI_API_KEY' },
      schema = { model = { default = 'gemini-2.5-pro-preview-05-06' } },
    })
  end,
}
