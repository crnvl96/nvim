vim.cmd('setlocal foldmethod=expr foldexpr=v:lua.MiniGit.diff_foldexpr() foldlevel=1')

MiniClue.ensure_buf_triggers(vim.api.nvim_get_current_buf())
