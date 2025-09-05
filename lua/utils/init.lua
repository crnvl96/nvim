---@class Utils.Aucmd
local M = {}

M.set = vim.keymap.set
M.aucmd = vim.api.nvim_create_autocmd

---@param name string Name of the Augroup which the autocmd will be attached to
---@param fn fun(g: integer): nil Autocmd callback
---@param opts? vim.api.keyset.create_augroup Augroup opts
function M.augroup(name, fn, opts)
  opts = vim.tbl_deep_extend('force', { clear = true }, opts or {})
  fn(vim.api.nvim_create_augroup(name, opts))
end

---@param name string Name of the command
---@param desc string Description of the usercmd
---@param fn fun(): nil Function to be executed
---@param opts? vim.api.keyset.user_command usercmd opts
function M.usercmd(name, desc, fn, opts)
  opts = vim.tbl_deep_extend('force', { desc = desc }, opts or {})
  vim.api.nvim_create_user_command(name, fn, opts)
end

--- A wrapper over vim.keymap.set with some presets
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param desc string Mapping description
---@param mode string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
---@param opts? vim.keymap.set.Opts Keymap options
---@return nil
function M.map(lhs, rhs, desc, mode, opts)
  opts = vim.tbl_deep_extend('force', { silent = true, noremap = true, desc = desc }, opts or {})
  M.set(mode, lhs, rhs, opts)
end

--- Sets a map for lsp events
---@param bufnr integer id of the buffer being attached into
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param desc string Mapping description
---@param mode? string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
---@return nil
function M.lspmap(bufnr, lhs, rhs, desc, mode)
  mode = mode or 'n'
  M.map(lhs, rhs, desc, mode, { buffer = bufnr, nowait = true })
end

--- Sets a map in normal mode
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param desc string Mapping description
---@param opts? vim.keymap.set.Opts Keymap options
---@return nil
function M.nmap(lhs, rhs, desc, opts) M.map(lhs, rhs, desc, 'n', opts) end

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

--- A small wrapper that auto handles the cleaning of published notifications
---@param msg string Msg to be published
---@param lvl? vim.log.levels Lvl of the publication. Defaults to INFO
---@return nil
function M.publish(msg, lvl)
  lvl = lvl or vim.log.levels.INFO
  vim.notify(msg, lvl)
end

return M
