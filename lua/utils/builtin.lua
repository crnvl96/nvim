---@class Utils.Builtin
local M = {}

--- Override a highlight group with custom opts
---@param hl_name string Name of the highlight to be overriden
---@param opts vim.api.keyset.highlight Opts to override the original highlight
---@return nil
function M.override_highlight(hl_name, opts)
  local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl_name, link = false })
  if is_ok then
    vim.api.nvim_set_hl(0, hl_name, vim.tbl_deep_extend('force', hl_def --[[@as vim.api.keyset.highlight]], opts))
  end
end

return M
