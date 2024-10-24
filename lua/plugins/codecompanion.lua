return {
  'olimorris/codecompanion.nvim',
  cmd = 'CodeCompanion',
  opts = function()
    local function get_anthropic_adapter_opts()
      -- File is read from a local file, to avoid exposing our API key into
      -- shell environment
      local path = vim.fn.stdpath('config') .. '/anthropic'
      local file = io.open(path, 'r')
      local key

      -- If file exists, populate the "key" variable
      if file then
        key = file:read('*a'):gsub('%s+$', '')
        file:close()
      end

      local anthropic_opts = {
        -- Key retrieved from local path
        env = { api_key = key or '' },
        schema = {
          --  Check information about available models here:
          --
          -- https://docs.anthropic.com/en/docs/about-claude/models
          --
          model = { default = 'claude-3-5-haiku-20241022' },
        },
      }

      return require('codecompanion.adapters').extend('anthropic', anthropic_opts)
    end

    return {
      strategies = {
        chat = { adapter = 'anthropic' },
      },
      adapters = {
        anthropic = get_anthropic_adapter_opts,
      },
    }
  end,
  keys = {
    { '<Leader>ia', '<cmd>CodeCompanionActions<cr>', desc = 'Actions', mode = { 'n', 'v' } },
    { '<Leader>ic', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Chat', mode = { 'n', 'v' } },
    { 'ga', '<cmd>CodeCompanionChat Add<cr>', desc = 'Add to chat', mode = 'v' },
  },
}
