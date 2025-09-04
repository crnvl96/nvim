local U = require('utils')

require('snacks').setup({
  input = { enabled = true },
})

U.nmap('<Leader>s', function() Snacks.lazygit() end, 'LazyGit')
