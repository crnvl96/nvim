local snippets, config_path = require('mini.snippets'), vim.fn.stdpath('config')

snippets.setup({
  snippets = {
    snippets.gen_loader.from_file(config_path .. '/snippets/global.json'),
    snippets.gen_loader.from_lang({
      lang_patterns = {
        tsx = { 'jsx.json' },
        javascriptreact = { 'jsx.json' },
        typescriptreact = { 'jsx.json' },
        markdown_inline = { 'markdown.json' },
      },
    }),
  },
})
