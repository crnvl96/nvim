---@diagnostic disable: undefined-global

local ltr = MiniDeps.later

local function feedkeys(keys) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true) end
local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end

ltr(function()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lspattach', {}),
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)

      if not client then return end

      if client:supports_method 'textDocument/completion' then
        vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })

        vim.keymap.set('i', '<C-u>', '<C-x><C-n>')

        vim.keymap.set('i', '<cr>', function() return pumvisible() and '<C-y>' or '<cr>' end, { expr = true })

        vim.keymap.set('i', '<C-n>', function()
          if pumvisible() then
            feedkeys '<C-n>'
          else
            if next(vim.lsp.get_clients { bufnr = 0 }) then
              vim.lsp.completion.get()
            else
              if vim.bo.omnifunc == '' then
                feedkeys '<C-x><C-n>'
              else
                feedkeys '<C-x><C-o>'
              end
            end
          end
        end)

        vim.keymap.set('i', '<C-p>', function()
          if pumvisible() then
            feedkeys '<C-n>'
          else
            if next(vim.lsp.get_clients { bufnr = 0 }) then
              vim.lsp.completion.get()
            else
              if vim.bo.omnifunc == '' then
                feedkeys '<C-x><C-p>'
              else
                feedkeys '<C-x><C-o>'
              end
            end
          end
        end)

        vim.keymap.set({ 'i', 's' }, '<Tab>', function()
          if pumvisible() then
            feedkeys '<C-n>'
          else
            if next(vim.lsp.get_clients { bufnr = 0 }) then
              vim.lsp.completion.get()
            else
              if vim.bo.omnifunc == '' then
                feedkeys '<C-x><C-n>'
              else
                feedkeys '<C-x><C-o>'
              end
            end
          end
        end)

        vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
          if pumvisible() then
            feedkeys '<C-p>'
          else
            if next(vim.lsp.get_clients { bufnr = 0 }) then
              vim.lsp.completion.get()
            else
              if vim.bo.omnifunc == '' then
                feedkeys '<C-x><C-p>'
              else
                feedkeys '<C-x><C-o>'
              end
            end
          end
        end)
      end
    end,
  })
end)
