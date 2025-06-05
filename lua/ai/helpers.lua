local M = {}

function M.retrieve_llm_key(key_name)
  local filepath = vim.fn.stdpath 'config' .. '/.env'
  local file = io.open(filepath, 'r')

  if not file then return nil end

  for line in file:lines() do
    line = line:match '^%s*(.-)%s*$'

    if line ~= '' and not line:match '^#' then
      local eq_pos = line:find '='
      if eq_pos then
        local current_key = line:sub(1, eq_pos - 1)
        local current_value = line:sub(eq_pos + 1)

        current_key = current_key:match '^%s*(.-)%s*$'
        current_value = current_value:match '^%s*(.-)%s*$'

        if current_key == key_name then
          file:close()
          return current_value
        end
      end
    end
  end

  file:close()

  return nil
end

return M
