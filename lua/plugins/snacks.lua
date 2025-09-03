local U = require('utils')

require('snacks').setup({
  input = { enabled = true },
})

U.nmap('<Leader>gg', function() Snacks.lazygit() end, 'LazyGit')
