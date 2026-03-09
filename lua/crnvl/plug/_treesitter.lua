Config.on_packchanged('nvim-treesitter', { 'update' }, function(e)
  MiniMisc.log_add('Updating parsers', { name = e.data.spec.name, path = e.data.path })
  vim.cmd('TSUpdate')
  MiniMisc.log_add('Parsers updates', { name = e.data.spec.name, path = e.data.path })
end)

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
})

local function exists(parser)
  local result = vim.api.nvim_get_runtime_file('parser/' .. parser .. '.*', false)
  return #result == 0
end

require('nvim-treesitter').install(
  vim.iter(Config.parsers):filter(exists):flatten():totable()
)

local function lang_fts(lang)
  local fts = vim.treesitter.language.get_filetypes(lang)
  return fts
end

local pattern = vim.iter(Config.parsers):map(lang_fts):flatten():totable()

vim.api.nvim_create_autocmd('FileType', {
  group = Config.gr,
  pattern = pattern,
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
