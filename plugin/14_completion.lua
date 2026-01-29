---@diagnostic disable: undefined-global

local ltr = MiniDeps.later

local set = vim.keymap.set

local function _feedkeys(keys) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true) end
local function _pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end
local _navigate_completion_candidate = function(command)
  if _pumvisible() then
    _feedkeys(command)
  else
    if next(vim.lsp.get_clients { bufnr = 0 }) then
      vim.lsp.completion.get()
    else
      if vim.bo.omnifunc == '' then
        _feedkeys('<C-x>' .. command)
      else
        _feedkeys '<C-x><C-o>'
      end
    end
  end
end
local get_bufnr_completions = function() return '<C-x><C-n>' end
local choose_completion_candidate = function() return _pumvisible() and '<C-y>' or '<CR>' end
local navigate_completion_candidate_next = function() _navigate_completion_candidate '<C-n>' end
local navigate_completion_candidate_prev = function() _navigate_completion_candidate '<C-p>' end

ltr(function()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lspattach', {}),
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)

      if not client then return end

      if client:supports_method 'textDocument/completion' then
        vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })

        set('i', '<C-u>', get_bufnr_completions)
        set('i', '<CR>', choose_completion_candidate, { expr = true })
        set('i', '<C-n>', navigate_completion_candidate_next)
        set('i', '<C-p>', navigate_completion_candidate_prev)
        set('i', '<Tab>', navigate_completion_candidate_next)
        set('i', '<S-Tav>', navigate_completion_candidate_prev)
      end
    end,
  })
end)
