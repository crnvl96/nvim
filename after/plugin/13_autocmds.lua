local H = {}

local function augroup(name, fnc) fnc(vim.api.nvim_create_augroup(name, { clear = true })) end

local autocmd = vim.api.nvim_create_autocmd
local set = vim.keymap.set

augroup('crnvl96-minifiles-keymaps', function(g)
  autocmd('User', {
    group = g,
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local buf_id = args.data.buf_id

      H.map_split(buf_id, '<C-w>s', 'belowright horizontal')
      H.map_split(buf_id, '<C-w>v', 'belowright vertical')
    end,
  })
end)

augroup('crnvl96-minifiles-ui', function(g)
  autocmd('User', {
    group = g,
    pattern = 'MiniFilesWindowOpen',
    callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'rounded' }) end,
  })
end)

augroup('crnvl96-nvimlint-linters', function(g)
  local linters = {
    lua = {
      cond = function(buf) return vim.fs.root(buf, { 'selene.toml' }) ~= nil end,
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

  autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
    group = g,
    callback = function(e)
      local ft = vim.bo[e.buf].filetype
      local conf = linters[ft]
      if conf and (not conf.cond or conf.cond(e.buf)) then require('lint').try_lint(conf.linters) end
    end,
  })
end)

augroup('crnvl96-handle-autofmt', function(g)
  local function format(buf)
    require('conform').format({
      bufnr = buf or vim.api.nvim_get_current_buf(),
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = 'fallback',
    })
  end

  autocmd('BufWritePre', {
    group = g,
    callback = function(e)
      if not vim.g.autoformat then return end
      format(e.buf)
    end,
  })
end)

augroup('crnvl96-lsp-on-attach', function(g)
  autocmd('LspAttach', {
    group = g,
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  })
end)

---
--- Helpers
---

H.map_split = function(buf_id, lhs, direction)
  local minifiles = require('mini.files')

  local function rhs()
    local window = minifiles.get_explorer_state().target_window
    if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then return end

    local new_target_window
    vim.api.nvim_win_call(window, function()
      vim.cmd(direction .. ' split')
      new_target_window = vim.api.nvim_get_current_win()
    end)

    minifiles.set_target_window(new_target_window)
    minifiles.go_in({ close_on_file = true })
  end

  set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
end
