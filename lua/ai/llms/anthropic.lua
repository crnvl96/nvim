local helpers = require 'ai.helpers'
local retrieve_llm_key = helpers.retrieve_llm_key

return {
  name = 'anthropic',
  metadata = {
    console = 'https://console.anthropic.com/dashboard',
    model_list = 'https://docs.anthropic.com/en/docs/about-claude/models/all-models',
  },
  adapter = function()
    return require('codecompanion.adapters').extend('anthropic', {
      env = {
        api_key = retrieve_llm_key 'ANTHROPIC_API_KEY',
      },
      schema = {
        model = {
          default = 'claude-sonnet-4-20250514',
        },
      },
    })
  end,
}
