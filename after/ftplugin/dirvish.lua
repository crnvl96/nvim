vim.cmd([[nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>]])
vim.cmd([[silent! unmap <buffer> s]])
