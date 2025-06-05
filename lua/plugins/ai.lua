MiniDeps.later(function()
  local function build_mcp(params)
    vim.notify('Building mcphub.nvim', vim.log.levels.INFO)
    local obj = vim
      .system({ 'npm', 'install', '-g', 'mcp-hub@latest' }, { cwd = params.path })
      :wait()
    if obj.code == 0 then
      vim.notify('Building mcphub.nvim done', vim.log.levels.INFO)
    else
      vim.notify('Building mcphub.nvim failed', vim.log.levels.ERROR)
    end
  end

  MiniDeps.add {
    source = 'ravitemer/mcphub.nvim',
    hooks = {
      post_install = build_mcp,
      post_checkout = build_mcp,
    },
  }

  MiniDeps.add 'olimorris/codecompanion.nvim'

  require('mcphub').setup {
    config = vim.fn.expand '~/.config/nvim/mcp-servers.json',
  }

  require('codecompanion').setup {
    extensions = {
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = {
          show_result_in_chat = true,
          make_vars = true,
          make_slash_commands = true,
        },
      },
    },
    strategies = {
      chat = {
        adapter = require('ai.llms.openai').name,
        keymaps = { completion = { modes = { i = '<C-n>' } } },
        slash_commands = {
          file = { opts = { provider = 'fzf_lua' } },
          buffer = { opts = { provider = 'fzf_lua' } },
        },
      },
    },
    adapters = {
      openai = require('ai.llms.openai').adapter,
      anthropic = require('ai.llms.anthropic').adapter,
      gemini = require('ai.llms.gemini').adapter,
      deepseek = require('ai.llms.deepseek').adapter,
      xai = require('ai.llms.xai').adapter,
      venice = require('ai.llms.venice').adapter,
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<Leader>ca', '<cmd>CodeCompanionActions<cr>')
  vim.keymap.set({ 'n', 'v' }, '<Leader>cc', '<cmd>CodeCompanionChat Toggle<cr>')
  vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>')
end)
