vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
})

vim.api.nvim_create_autocmd('PackChanged', {
  group = Config.gr,
  callback = function(e)
    if e.data.spec.name == 'nvim-treesitter' and vim.tbl_contains({ 'update' }, e.data.kind) then
      if not e.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

Config.treesitter_langs = { 'python' }

vim
  .iter(Config.treesitter_langs)
  :filter(function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end)
  :each(function(lang) require('nvim-treesitter').install(lang) end)

vim.api.nvim_create_autocmd('FileType', {
  group = Config.gr,
  pattern = vim
    .iter(Config.treesitter_langs)
    :map(function(lang) return vim.treesitter.language.get_filetypes(lang) end)
    :flatten()
    :totable(),
  callback = function(e)
    local ft = vim.bo[e.buf].filetype
    if vim.treesitter.language.add(ft) then vim.treesitter.start(e.buf) end
  end,
})
