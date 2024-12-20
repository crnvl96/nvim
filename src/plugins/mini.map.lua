local map = require('mini.map')
local gen_integr = map.gen_integration
local encode_symbols = map.gen_encode_symbols.block('3x2')

if vim.startswith(vim.fn.getenv('TERM'), 'st') then encode_symbols = map.gen_encode_symbols.dot('4x2') end

map.setup({
  symbols = { encode = encode_symbols },
  integrations = { gen_integr.builtin_search(), gen_integr.diff(), gen_integr.diagnostic() },
})
