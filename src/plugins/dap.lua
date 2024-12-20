Add('mfussenegger/nvim-dap-python')
Add('theHamsta/nvim-dap-virtual-text')
Add('mfussenegger/nvim-dap')

local function json_decode(data)
  local decode = vim.json.decode
  local strip_comments = require('plenary.json').json_strip_comments
  data = strip_comments(data)

  return decode(data)
end

vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

local debugpy = require('mason-registry').get_package('debugpy'):get_install_path()

require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })
require('dap-python').setup(debugpy .. '/venv/bin/python')
require('dap.ext.vscode').json_decode = json_decode
