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

  require('mcphub').setup {
    config = vim.fn.expand '~/.config/nvim/mcphub/servers.json',
  }
end)
