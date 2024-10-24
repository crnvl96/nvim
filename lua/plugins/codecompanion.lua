return {
  'olimorris/codecompanion.nvim',
  cmd = 'CodeCompanion',
  opts = function()
    local path = vim.fn.stdpath('config') .. '/anthropic'
    local file = io.open(path, 'r')
    local key

    if file then
      key = file:read('*a'):gsub('%s+$', '')
      file:close()
    end

    local anthropic_opts = {
      env = {
        api_key = key,
      },
      schema = {
        model = {
          default = 'claude-3-5-haiku-20241022',
        },
      },
    }

    return {
      strategies = {
        chat = {
          adapter = 'anthropic',
        },
      },
      adapters = {
        anthropic = function() return require('codecompanion.adapters').extend('anthropic', anthropic_opts) end,
      },
    }
  end,
  keys = {
    { '<Leader>ia', '<cmd>CodeCompanionActions<cr>', desc = 'Actions', mode = { 'n', 'v' } },
    { '<Leader>ic', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Chat', mode = { 'n', 'v' } },
    { 'ga', '<cmd>CodeCompanionChat Add<cr>', desc = 'Add to chat', mode = 'v' },
  },
}
