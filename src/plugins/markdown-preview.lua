local function build_mkdp(params)
  vim.notify('Building mkdp', vim.log.levels.INFO)
  local obj = vim.system({ 'cd', 'app', '&&', 'npm', 'install' }, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building mkdp done', vim.log.levels.INFO)
  else
    vim.notify('Building mkdp failed', vim.log.levels.ERROR)
  end
end

Add({
  source = 'iamcco/markdown-preview.nvim',
  hooks = {
    post_install = build_mkdp,
    post_checkout = build_mkdp,
  },
})

vim.cmd([[do FileType]])
