local ensure_installed = {
  'bash',
  'css',
  'diff',
  'go',
  'html',
  'javascript',
  'json',
  'python',
  'regex',
  'rust',
  'toml',
  'tsx',
  'yaml',
}

local isnt_installed = function(lang)
  return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
end

local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
if #to_install > 0 then require('nvim-treesitter').install(to_install) end

local filetypes = vim
  .iter(ensure_installed)
  :map(vim.treesitter.language.get_filetypes)
  :flatten()
  :totable()

vim.list_extend(filetypes, { 'markdown', 'pandoc' })

local ts_start = function(ev) vim.treesitter.start(ev.buf) end

vim.api.nvim_create_autocmd(
  'FileType',
  { pattern = filetypes, callback = ts_start }
)

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(e)
    local spec = e.data.spec

    if spec and spec.name == 'nvim-treesitter' and e.data.kind == 'update' then
      vim.notify(
        'nvim-treesitter was updated, running :TSUpdate',
        vim.log.levels.INFO
      )
      vim.schedule(function() vim.cmd('TSUpdate') end)
    end
  end,
})
