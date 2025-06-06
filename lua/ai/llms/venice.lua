local helpers = require 'ai.helpers'
local retrieve_llm_key = helpers.retrieve_llm_key

return {
  name = 'venice',
  metadata = {
    console = 'https://venice.ai/settings/api',
    model_list = 'https://docs.venice.ai/api-reference/endpoint/models/list?playground=open',
  },
  adapter = function()
    return require('codecompanion.adapters').extend('openai_compatible', {
      name = 'venice',
      formatted_name = 'Venice',
      env = {
        url = 'https://api.venice.ai/api',
        chat_url = '/v1/chat/completions',
        api_key = retrieve_llm_key 'VENICE_API_KEY',
      },
      schema = {
        model = {
          default = 'dolphin-2.9.2-qwen2-72b',
        },
        temperature = {
          order = 2,
          mapping = 'parameters',
          type = 'number',
          optional = true,
          default = 0.8,
          desc = 'What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.',
          validate = function(n) return n >= 0 and n <= 2, 'Must be between 0 and 2' end,
        },
        max_completion_tokens = {
          order = 3,
          mapping = 'parameters',
          type = 'integer',
          optional = true,
          default = nil,
          desc = 'An upper bound for the number of tokens that can be generated for a completion.',
          validate = function(n) return n > 0, 'Must be greater than 0' end,
        },
        presence_penalty = {
          order = 4,
          mapping = 'parameters',
          type = 'number',
          optional = true,
          default = 0,
          desc = 'Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model\'s likelihood to talk about new topics.',
          validate = function(n) return n >= -2 and n <= 2, 'Must be between -2 and 2' end,
        },
        top_p = {
          order = 5,
          mapping = 'parameters',
          type = 'number',
          optional = true,
          default = 0.9,
          desc = 'A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text. (Default: 0.9)',
          validate = function(n) return n >= 0 and n <= 1, 'Must be between 0 and 1' end,
        },
        stop = {
          order = 6,
          mapping = 'parameters',
          type = 'string',
          optional = true,
          default = nil,
          desc = 'Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.',
          validate = function(s) return s:len() > 0, 'Cannot be an empty string' end,
        },
        frequency_penalty = {
          order = 8,
          mapping = 'parameters',
          type = 'number',
          optional = true,
          default = 0,
          desc = 'Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model\'s likelihood to repeat the same line verbatim.',
          validate = function(n) return n >= -2 and n <= 2, 'Must be between -2 and 2' end,
        },
        logit_bias = {
          order = 9,
          mapping = 'parameters',
          type = 'map',
          optional = true,
          default = nil,
          desc = 'Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.',
          subtype_key = {
            type = 'integer',
          },
          subtype = {
            type = 'integer',
            validate = function(n)
              return n >= -100 and n <= 100, 'Must be between -100 and 100'
            end,
          },
        },
      },
      roles = {
        llm = 'assistant',
        user = 'user',
      },
      opts = {
        stream = true,
      },
      features = {
        text = true,
        tokens = true,
        vision = false,
      },
    })
  end,
}
