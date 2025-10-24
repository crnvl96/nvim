vim.cmd 'setlocal spell wrap'
vim.cmd 'setlocal colorcolumn=81'
vim.cmd 'setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()'

vim.bo.shiftwidth = 2

vim.keymap.del('n', 'gO', { buffer = 0 })

vim.b.minisurround_config = {
  custom_surroundings = {
    L = {
      input = { '%[().-()%]%(.-%)' },
      output = function()
        local link = require('mini.surround').user_input 'Link: '
        return { left = '[', right = '](' .. link .. ')' }
      end,
    },
  },
}
