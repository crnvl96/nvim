_G.Config = {}

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

require('mini.misc').setup()
require('mini.extra').setup()

MiniMisc.setup_auto_root()
MiniMisc.setup_restore_cursor()
MiniMisc.setup_termbg_sync()

vim.cmd.colorscheme([[miniwinter]])

Config.gr = vim.api.nvim_create_augroup('custom-config', {})

function Config.now(f) MiniMisc.safely('now', f) end
function Config.later(f) MiniMisc.safely('later', f) end

Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

function Config.on_packchanged(name, kinds, callback)
  vim.api.nvim_create_autocmd('PackChanged', {
    group = Config.gr,
    callback = function(e)
      local is_target = e.data.spec.name == name and vim.tbl_contains(kinds, e.data.kind)

      if not is_target then return end

      if not e.data.active then vim.cmd.packadd(name) end

      callback(e)
    end,
  })
end

Config.later(function()
  local hint = vim.diagnostic.severity.HINT
  local warn = vim.diagnostic.severity.WARN
  local error = vim.diagnostic.severity.ERROR

  vim.diagnostic.config({
    virtual_lines = false,
    update_in_insert = false,
    signs = { priority = 9999, severity = { min = warn, max = error } },
    underline = { severity = { min = hint, max = error } },
    virtual_text = {
      current_line = true,
      severity = { min = error, max = error },
    },
  })
end)

Config.servers = {
  'biome',
  'eslint',
  'gopls',
  'lua_ls',
  'oxfmt',
  'oxlint',
  'rubocop',
  'ruby_lsp',
  'ruff',
  'tinymist',
  'tailwindcss',
  'tsgo',
  'ty',
  'jsonls',
  'yamlls',
  -- 'pyright',
  -- 'harper_ls'
}

Config.parsers = {
  -- NOTE: parsers for c, lua, vim, vimdoc, query and markdown are already included in neovim
  'bash',
  'c',
  'css',
  'diff',
  'dockerfile',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'html',
  'javascript',
  'json',
  'json5',
  'jsx',
  'lua',
  'markdown',
  'python',
  'regex',
  'ruby',
  'toml',
  'tsx',
  'typescript',
  'typst',
  'vim',
  'vimdoc',
  'yaml',
  'jsdoc',
}
