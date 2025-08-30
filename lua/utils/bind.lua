---@class Utils.Bind
local M = {}

local set = vim.keymap.set

--- A wrapper over vim.keymap.set with some presets
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param desc string Mapping description
---@param mode string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
---@param opts? vim.keymap.set.Opts Keymap options
---@return nil
function M.map(lhs, rhs, desc, mode, opts)
  opts = vim.tbl_deep_extend('force', { silent = true, noremap = true, desc = desc }, opts or {})
  set(mode, lhs, rhs, opts)
end

--- Sets a map in normal mode
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param desc string Mapping description
---@return nil
function M.nmap(lhs, rhs, desc) M.map(lhs, rhs, desc, 'n') end

--- Sets a map in visual mode
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param desc string Mapping description
---@return nil
function M.xmap(lhs, rhs, desc) M.map(lhs, rhs, desc, 'x') end

--- Sets a map in terminal mode
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param desc string Mapping description
---@return nil
function M.tmap(lhs, rhs, desc) M.map(lhs, rhs, desc, 't') end

return M
