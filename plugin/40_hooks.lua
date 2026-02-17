vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('markdown-preview.nvim-hooks', { clear = true }),
  pattern = '*',
  callback = function(e)
    local name, kind = e.data.spec.name, e.data.kind
    if not (name == 'markdown-preview.nvim' and vim.tbl_contains({ 'install', 'update' }, kind)) then return end
    local cmd = { 'npm', 'install', '--prefix', string.format('%s/app', e.data.path) }
    vim.system(cmd):wait()
  end,
  desc = 'Markdown Preview hooks',
})

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('nvim-treesitter-hooks', { clear = true }),
  pattern = '*',
  callback = function(e)
    local name, kind = e.data.spec.name, e.data.kind
    if not (name == 'nvim-treesitter' and vim.tbl_contains({ 'update' }, kind)) then return end
    if not e.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end,
  desc = 'Nvim Treesitter hooks',
})
