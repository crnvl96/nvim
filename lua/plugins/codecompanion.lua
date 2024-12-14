return {
  'olimorris/codecompanion.nvim',
  opts = function()
    local path = vim.fn.stdpath('config') .. '/anthropic'
    local file = io.open(path, 'r')
    local key

    if file then
      key = file:read('*a'):gsub('%s+$', '')
      file:close()
    end

    return {
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
    }
  end,
  keys = {
    { '<Leader>ii', '<cmd>CodeCompanionActions<cr>', desc = 'codecompanion: actions', mode = { 'n', 'v' } },
    { '<Leader>ic', '<cmd>CodeCompanionChat toggle<cr>', desc = 'codecompanion: chat', mode = { 'n', 'v' } },
    { 'ga', '<cmd>CodeCompanionChat Add<cr>', desc = 'codecompanion: add to chat', mode = 'v' },
  },
}
