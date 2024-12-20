-- Use custom comment leaders to allow both nested variants (`--` and `----`)
-- and "docgen" variant (`---`).
vim.bo.comments = ':---,:--'

local has_mini_ai = pcall(require, 'mini.ai')
local has_mini_splitjoin, mini_splitjoin = pcall(require, 'mini.splitjoin')
local has_mini_doc, mini_doc = pcall(require, 'mini.doc')

if has_mini_ai then vim.b.miniai_config = {
  custom_textobjects = {
    s = { '%[%[().-()%]%]' },
  },
} end

if has_mini_doc then
  vim.keymap.set('n', '<leader>cg', function() mini_doc.generate() end, { desc = '(lua) minidoc: generate' })
end

if has_mini_splitjoin then
  local gen_hook = mini_splitjoin.gen_hook

  local curly = { brackets = { '%b{}' } }

  -- Add trailing comma when splitting inside curly brackets
  local add_comma_curly = gen_hook.add_trailing_separator(curly)

  -- Delete trailing comma when joining inside curly brackets
  local del_comma_curly = gen_hook.del_trailing_separator(curly)

  -- Pad curly brackets with single space after join
  local pad_curly = gen_hook.pad_brackets(curly)

  vim.b.minisplitjoin_config = {
    split = { hooks_post = { add_comma_curly } },
    join = { hooks_post = { del_comma_curly, pad_curly } },
  }
end

-- stylua: ignore
vim.keymap.set('n', '<leader>LL', '<Cmd>luafile %<CR><Cmd>echo "Sourced lua"<CR>', { desc = '(lua) lua: source buffer' })

local has_mini_clue = pcall(require, 'mini.clue')

if has_mini_clue then
  local tg = vim.deepcopy(vim.b.miniclue_config)

  local conf = {
    clues = {
      { mode = 'n', keys = '<leader>L', desc = '+lua' },
    },
  }

  if not tg then
    vim.b.miniclue_config = conf
    return
  end

  for k, v in pairs(conf) do
    if not tg[k] then
      tg[k] = v
    else
      vim.list_extend(tg[k], v)
    end
  end

  vim.b.miniclue_config = tg
end
