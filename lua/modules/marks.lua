local ns = vim.api.nvim_create_namespace('crnvl96-marks')

--- Decorate the mark
---@param bufnr integer buffer id
---@param mark vim.fn.getmarklist.ret.item mark itself
---@return nil
local function decor_mark(bufnr, mark)
  pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, mark.pos[2] - 1, 0, {
    sign_text = mark.mark:sub(2),
    sign_hl_group = 'DiagnosticSignOk',
  })
end

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, _, bufnr, top_row, bot_row)
    if vim.api.nvim_buf_get_name(bufnr) == '' then return end
    vim.api.nvim_buf_clear_namespace(bufnr, ns, top_row, bot_row)
    local current_file = vim.api.nvim_buf_get_name(bufnr)

    for _, mark in ipairs(vim.fn.getmarklist()) do
      if mark.mark:match('^.[a-zA-Z]$') then
        local mark_file = vim.fn.fnamemodify(mark.file, ':p:a')
        if current_file == mark_file then decor_mark(bufnr, mark) end
      end
    end

    for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
      if mark.mark:match('^.[a-zA-Z]$') then decor_mark(bufnr, mark) end
    end
  end,
})

vim.on_key(function(_, typed)
  if typed:sub(1, 1) ~= 'm' then return end
  local mark = typed:sub(2)
  vim.schedule(function()
    if mark:match('[A-Z]') then
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        vim.api.nvim__redraw({ win = win, range = { 0, -1 } })
      end
    else
      vim.api.nvim__redraw({ range = { 0, -1 } })
    end
  end)
end, ns)
