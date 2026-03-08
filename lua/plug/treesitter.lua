Config.on_packchanged('nvim-treesitter', { 'update' }, function(e)
  MiniMisc.log_add('Updating parsers', { name = e.data.spec.name, path = e.data.path })
  vim.cmd('TSUpdate')
  MiniMisc.log_add('Parsers updates', { name = e.data.spec.name, path = e.data.path })
end)

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
})

require('nvim-treesitter').install(
  vim.iter(Config.parsers):filter(function(item) return #vim.api.nvim_get_runtime_file('parser/' .. item .. '.*', false) == 0 end):flatten():totable()
)

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-nvim-treesitter', {}),
  pattern = vim.iter(Config.parsers):map(function(item) return vim.treesitter.language.get_filetypes(item) end):flatten():totable(),
  callback = function(ev) vim.treesitter.start(ev.buf) end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = Config.gr,
  callback = function()
    vim.cmd('setlocal formatoptions-=c formatoptions-=o')
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
  end,
})
