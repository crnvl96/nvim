require('mini.icons').setup()
require('snacks').setup(Utils.qol)

vim.print = function(...) Snacks.debug.inspect(...) end

require('nvim-treesitter.configs').setup(Utils.treesitter)

require('mini.align').setup()
require('csvview').setup()

require('blink.compat').setup()
require('blink.cmp').setup(Utils.completion)
require('conform').setup(Utils.formatters)

require('dap-view').setup()
require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })
require('dap.ext.vscode').json_decode = Utils.json_decoder
require('dap-python').setup('uv')

require('mini.files').setup(Utils.fm)
require('mini.clue').setup(Utils.clues)

for server, config in pairs(Utils.servers) do
  config = config or {}
  config.capabilities = require('blink.cmp').get_lsp_capabilities(Utils.capabilities)
  require('lspconfig')[server].setup(config)
end
