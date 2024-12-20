local miniclue = require('mini.clue')

local function mark_clues()
  local marks = {}
  vim.list_extend(marks, vim.fn.getmarklist(vim.api.nvim_get_current_buf()))
  vim.list_extend(marks, vim.fn.getmarklist())

  return vim
    .iter(marks)
    :map(function(mark)
      local key = mark.mark:sub(2, 2)

      -- Just look at letter marks.
      if not string.match(key, '^%a') then return nil end

      -- For global marks, use the file as a description.
      -- For local marks, use the line number and content.
      local desc
      if mark.file then
        desc = vim.fn.fnamemodify(mark.file, ':p:~:.')
      elseif mark.pos[1] and mark.pos[1] ~= 0 then
        local line_num = mark.pos[2]
        local lines = vim.fn.getbufline(mark.pos[1], line_num)
        if lines and lines[1] then desc = string.format('%d: %s', line_num, lines[1]:gsub('^%s*', '')) end
      end

      if desc then
        return {
          { mode = 'n', keys = string.format('`%s', key), desc = desc },
          { mode = 'n', keys = string.format("'%s", key), desc = desc },
        }
      end
    end)
    :totable()
end

local function macro_clues()
  local res = {}
  for _, register in ipairs(vim.split('abcdefghijklmnopqrstuvwxyz', '')) do
    local keys = string.format('"%s', register)
    local ok, desc = pcall(vim.fn.getreg, register)
    if ok and desc ~= '' then
      ---@cast desc string
      desc = string.format('register: %s', desc:gsub('%s+', ' '))
      table.insert(res, { mode = 'n', keys = keys, desc = desc })
      table.insert(res, { mode = 'v', keys = keys, desc = desc })
    end
  end

  return res
end

miniclue.setup({
  clues = {
    { mode = 'n', keys = '<leader>b', desc = '+buffer' },
    { mode = 'n', keys = '<leader>c', desc = '+code' },
    { mode = 'n', keys = '<leader>d', desc = '+dap' },
    { mode = 'n', keys = '<leader>f', desc = '+files' },
    { mode = 'n', keys = '<leader>g', desc = '+git' },
    { mode = 'n', keys = '<leader>i', desc = '+ia' },
    { mode = 'n', keys = '<leader>m', desc = '+map' },
    { mode = 'n', keys = '<leader>u', desc = '+toggle' },
    { mode = 'n', keys = '<leader>x', desc = '+qf' },

    { mode = 'x', keys = '<leader>c', desc = '+code' },
    { mode = 'x', keys = '<leader>d', desc = '+dap' },
    { mode = 'x', keys = '<leader>g', desc = '+git' },
    { mode = 'x', keys = '<leader>i', desc = '+ia' },

    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows({ submode_resize = true }),
    miniclue.gen_clues.z(),

    mark_clues,
    macro_clues,
  },
  triggers = {
    { mode = 'n', keys = '<Leader>' }, -- Leader triggers
    { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = '<Localleader>' }, -- Localleader triggers
    { mode = 'x', keys = '<Localleader>' },
    { mode = 'n', keys = [[\]] }, -- mini.basics
    { mode = 'n', keys = '[' }, -- mini.bracketed
    { mode = 'n', keys = ']' },
    { mode = 'x', keys = '[' },
    { mode = 'x', keys = ']' },
    { mode = 'i', keys = '<C-x>' }, -- Built-in completion
    { mode = 'n', keys = 'g' }, -- `g` key
    { mode = 'x', keys = 'g' },
    { mode = 'n', keys = "'" }, -- Marks
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },
    { mode = 'n', keys = '"' }, -- Registers
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' }, -- Window commands
    { mode = 'n', keys = 'z' }, -- `z` key
    { mode = 'x', keys = 'z' },
  },
  window = {
    delay = 200,
    config = { border = 'double', width = 'auto' },
  },
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl-enable-clues-by-ft', { clear = true }),
  once = true,
  pattern = { 'codecompanion' },
  callback = function(e) MiniClue.enable_buf_triggers(e.buf) end,
})
