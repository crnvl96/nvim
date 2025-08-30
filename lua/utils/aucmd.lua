---@class Utils.Aucmd
local M = {}

M.aucmd = vim.api.nvim_create_autocmd

---@param name string Name of the Augroup which the autocmd will be attached to
---@param fn fun(g: integer): nil Autocmd callback
---@param opts? vim.api.keyset.create_augroup Augroup opts
function M.augroup(name, fn, opts)
  opts = vim.tbl_deep_extend('force', { clear = true }, opts or {})
  fn(vim.api.nvim_create_augroup(name, opts))
end

return M
