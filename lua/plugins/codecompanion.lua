return {
  'olimorris/codecompanion.nvim',
  cmd = 'CodeCompanion',
  init = function()
    local M = require('config.functions')

    M.au('User', {
      pattern = 'CodeCompanionInline*',
      group = M.group('crnvl96-codecompanion-hooks', { clear = true }),
      callback = function(request)
        if request.match == 'CodeCompanionInlineFinished' then
          if M.has('conform.nvim') then require('conform').format({ bufnr = request.buf }) end
        end
      end,
    })
  end,
  opts = function()
    local function get_anthropic_adapter_opts()
      local path = vim.fn.stdpath('config') .. '/anthropic'
      local file = io.open(path, 'r')
      local key

      if file then
        key = file:read('*a'):gsub('%s+$', '')
        file:close()
      end

      local anthropic_opts = {
        env = { api_key = key or '' },
        schema = {
          --  Check information about available models here:
          --
          -- https://docs.anthropic.com/en/docs/about-claude/models
          --
          model = {
            default = 'claude-3-5-sonnet-20241022',
            -- default = 'claude-3-5-haiku-20241022'
          },
        },
      }

      return require('codecompanion.adapters').extend('anthropic', anthropic_opts)
    end

    return {
      strategies = {
        chat = { adapter = 'anthropic' },
        inline = { adapter = 'anthropic' },
        cmd = { adapter = 'anthropic' },
      },
      adapters = {
        anthropic = get_anthropic_adapter_opts,
      },
      display = {
        chat = {
          window = {
            layout = 'buffer',
          },
        },
      },
    }
  end,
  keys = {
    { '<Leader>ia', '<cmd>CodeCompanionActions<cr>', desc = 'Actions', mode = { 'n', 'v' } },
    { '<Leader>ic', '<cmd>CodeCompanionChat<cr>', desc = 'Chat', mode = { 'n', 'v' } },
    { 'ga', '<cmd>CodeCompanionChat Add<cr>', desc = 'Add to chat', mode = 'v' },
  },
}
