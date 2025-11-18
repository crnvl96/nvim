vim.cmd 'setlocal wrap'
vim.cmd 'setlocal foldmethod=expr'
vim.cmd 'setlocal foldexpr=v:lua.MiniGit.diff_foldexpr()'
vim.cmd 'setlocal foldlevel=1'
