local U = require('utils')

require('nvim-treesitter').install({
  'c',
  'lua',
  'vimdoc',
  'query',
  'markdown',
  'markdown_inline',
  'javascript',
  'typescript',
  'tsx',
  'jsx',
  'python',
  'rust',
  'ron',
  'bash',
  'gitcommit',
  'html',
  'hyprlang',
  'json',
  'json5',
  'jsonc',
  'rasi',
  'regex',
  'scss',
  'toml',
  'vim',
  'yaml',
})

U.augroup('crnvl96-treesitter-start', function(g)
  U.aucmd('FileType', {
    group = g,
    callback = function(e)
      local filetype = e.match
      local lang = vim.treesitter.language.get_lang(filetype) or ''

      if vim.treesitter.language.add(lang) then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.treesitter.start()
      end
    end,
  })
end)
