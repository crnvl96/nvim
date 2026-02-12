local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')

  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim',
    mini_path,
  })

  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup()

MiniDeps.later(function()
  if vim.fn.executable('rg') == 1 then
    function _G.FindFunc(cmdarg)
      local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
      return #cmdarg == 0 and fnames or vim.fn.matchfuzzy(fnames, cmdarg)
    end
    vim.o.findfunc = 'v:lua.FindFunc'
    local l = ''
  end
end)

MiniDeps.later(
  function()
    vim.diagnostic.config({
      signs = {
        priority = 9999,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      underline = {
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      virtual_text = {
        current_line = true,
        severity = {
          min = vim.diagnostic.severity.ERROR,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      virtual_lines = false,
      update_in_insert = false,
    })
  end
)
