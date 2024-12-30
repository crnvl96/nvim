--- Checks if a lua table is an array or not
---@param t table
---@return boolean
local function is_array(t)
  for i, _ in pairs(t) do
    if type(i) ~= 'number' then return false end
  end

  return true
end

local function merge(dest, src)
  for k, v in pairs(src) do
    local tgt = rawget(dest, k)

    if type(v) == 'table' and type(tgt) == 'table' then
      if is_array(v) and is_array(tgt) then
        dest[k] = vim.list_extend(vim.deepcopy(tgt), v)
      else
        merge(tgt, v)
      end
    else
      dest[k] = vim.deepcopy(v)
    end
  end

  return dest
end

function Config.extend(b, n)
  local base = vim.deepcopy(b or {})
  local new = vim.deepcopy(n or {})
  if is_array(base) and is_array(new) then return vim.list_extend(base, new) end
  return merge(base, new)
end

function Config.check_cli_requirements()
  local tools = {
    'zathura',
    'tex-fmt',
    'tree-sitter',
    'rg',
    'rustc',
    'npm',
  }

  for _, cli in ipairs(tools) do
    if vim.fn.executable(cli) ~= 1 then
      local msg = cli .. ' is not installed in the system.'
      local lvl = vim.log.levels.ERROR

      vim.notify(msg, lvl)
    end
  end
end

function Config.json_decode(data)
  local decode = vim.json.decode
  local strip_comments = require('plenary.json').json_strip_comments
  data = strip_comments(data)

  return decode(data)
end

--- Retrieve a LLM (in this case, from anthropic) from a local file, and returns it
--- to be integrated with relevant plugins.
---
--- This is done this way to avoid exposing the private key in the running shell session via environment keys.
---@return string?
function Config.retrieve_llm_key()
  ---@type string
  local path = vim.fn.stdpath('config') .. '/anthropic'
  ---@type file*?
  local file = io.open(path, 'r')
  ---@type string?
  local key

  if file then
    ---@type string?
    key = file:read('*a'):gsub('%s+$', '')
    file:close()
  end

  return key or nil
end

---@return string?
function Config.get_install_path(tool)
  local path = require('mason-registry').get_package(tool):get_install_path()
  return path or nil
end

---@class LinterConfig
---@field cond? fun(buf: number): boolean
---@field linters string[]

---@return table<string, LinterConfig>
function Config.linters_by_ft()
  return {
    lua = {
      condddd = function(buf) return vim.fs.root(buf, { 'selene.toml' }) ~= nil end,
      linters = { 'selene' },
    },
    python = { linters = { 'ruff' } },
    javascript = { linters = { 'eslint_d' } },
    typescript = { linters = { 'eslint_d' } },
    javascriptreact = { linters = { 'eslint_d' } },
    typescriptreact = { linters = { 'eslint_d' } },
    ['javascript.tsx'] = { linters = { 'eslint_d' } },
    ['typescript.tsx'] = { linters = { 'eslint_d' } },
  }
end

function Config.formatters_by_ft()
  return {
    markdown = { 'prettierd', 'injected' },
    css = { 'prettierd' },
    tex = { 'tex-fmt' },
    html = { 'prettierd' },
    json = { 'prettierd' },
    toml = { 'taplo' },
    lua = { 'stylua' },
    javascript = { 'deno_fmt', 'prettierd' },
    typescript = { 'deno_fmt', 'prettierd' },
    javascriptreact = { 'deno_fmt', 'prettierd' },
    typescriptreact = { 'deno_fmt', 'prettierd' },
    ['javascript.tsx'] = { 'deno_fmt', 'prettierd' },
    ['typescript.tsx'] = { 'deno_fmt', 'prettierd' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
  }
end

function Config.formatters_settings()
  return {
    injected = { ignore_errors = true },
    prettierd = {
      condition = function()
        local buffer = vim.api.nvim_get_current_buf()
        return (
          vim.tbl_contains({
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          }, vim.bo[buffer].filetype) and not vim.fs.root(buffer, { 'package.json' })
        ) or true
      end,
    },
    deno_fmt = {
      condition = function()
        return vim.fs.root(vim.api.nvim_get_current_buf(), { 'deno.json', 'deno.jsonc' }) and true or false
      end,
    },
  }
end

function Config.toggle_quickfix()
  local quickfix_wins = vim.tbl_filter(
    function(win_id) return vim.fn.getwininfo(win_id)[1].quickfix == 1 end,
    vim.api.nvim_tabpage_list_wins(0)
  )

  local command = #quickfix_wins == 0 and 'copen' or 'cclose'
  vim.cmd(command)
end

function Config.capabilities()
  local ok = pcall(require, 'blink.cmp')
  local default = vim.lsp.protocol.make_client_capabilities()
  if not ok then
    vim.notify('blink.cmp must be installed to have access to full capabilities.', vim.log.levels.ERROR)
    return default
  end
  return require('blink.cmp').get_lsp_capabilities(default)
end

function Config.on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  Config.on_attach_maps(bufnr)
end

function Config.clues()
  return {
    { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
    { mode = 'n', keys = '<Leader>c', desc = '+Code' },
    { mode = 'n', keys = '<Leader>d', desc = '+Debug' },
    { mode = 'n', keys = '<Leader>f', desc = '+Files' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'x', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>i', desc = '+IA' },
    { mode = 'x', keys = '<Leader>i', desc = '+IA' },
    { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
    { mode = 'n', keys = '<Leader>x', desc = '+List' },
  }
end

function Config.triggers()
  return {
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = '<Localleader>' },
    { mode = 'x', keys = '<Localleader>' },
    { mode = 'n', keys = [[\]] },
    { mode = 'n', keys = '[' },
    { mode = 'x', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'x', keys = ']' },
    { mode = 'i', keys = '<C-x>' },
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
    { mode = 'n', keys = "'" },
    { mode = 'x', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = '`' },
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  }
end

function Config.multigrep()
  MiniPick.registry.multigrep = function()
    local process
    local symbol = '::'
    local set_items_opts = { do_match = false }
    local spawn_opts = { cwd = vim.uv.cwd() }

    local match = function(_, _, query)
      pcall(vim.loop.process_kill, process)
      if #query == 0 then return MiniPick.set_picker_items({}, set_items_opts) end
      local full_query = table.concat(query)
      local parts = vim.split(full_query, symbol, { plain = true })

      -- First part is always the search pattern
      local search_pattern = parts[1] and parts[1] ~= '' and parts[1] or nil

      local command = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
      }

      -- Add search pattern if exists
      if search_pattern then
        table.insert(command, '-e')
        table.insert(command, search_pattern)
      end

      -- Process file patterns
      local include_patterns = {}
      local exclude_patterns = {}

      for i = 2, #parts do
        local pattern = parts[i]
        if pattern:sub(1, 1) == '!' then
          table.insert(exclude_patterns, pattern:sub(2))
        else
          table.insert(include_patterns, pattern)
        end
      end

      if #include_patterns > 0 then
        for _, pattern in ipairs(include_patterns) do
          table.insert(command, '-g')
          table.insert(command, pattern)
        end
      end

      if #exclude_patterns > 0 then
        for _, pattern in ipairs(exclude_patterns) do
          table.insert(command, '-g')
          table.insert(command, '!' .. pattern)
        end
      end

      process = MiniPick.set_picker_items_from_cli(command, {
        postprocess = function(lines)
          local results = {}
          for _, line in ipairs(lines) do
            if line ~= '' then
              local file, lnum, col = line:match('([^:]+):(%d+):(%d+):(.*)')
              if file then
                results[#results + 1] = {
                  path = file,
                  lnum = tonumber(lnum),
                  col = tonumber(col),
                  text = line,
                }
              end
            end
          end
          return results
        end,
        set_items_opts = set_items_opts,
        spawn_opts = spawn_opts,
      })
    end

    return MiniPick.start({
      source = {
        items = {},
        name = 'Multi Grep',
        match = match,
        show = function(buf_id, items_to_show, query)
          MiniPick.default_show(buf_id, items_to_show, query, { show_icons = true })
        end,
        choose = MiniPick.default_choose,
      },
    })
  end
end

function Config.build(params, build_cmd)
  vim.notify('Building ' .. params.name, vim.log.levels.INFO)
  local obj = vim.system(build_cmd, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building ' .. params.name .. ' done', vim.log.levels.INFO)
  else
    vim.notify('Building ' .. params.name .. ' failed', vim.log.levels.ERROR)
  end
end

function Config.refresh_registry()
  local mr = require('mason-registry')

  mr.refresh(function()
    for _, tool in ipairs({
      -- javascript/typescript
      'vtsls',
      'eslint_d',
      'deno',
      'prettierd',

      -- lua
      'lua-language-server',
      'stylua',
      'selene',

      -- python
      'basedpyright',
      'ruff',
      'debugpy',

      -- LaTex
      'tectonic',
    }) do
      local p = mr.get_package(tool)
      if not p:is_installed() then p:install() end
    end
  end)
end
