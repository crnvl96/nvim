vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  group = Config.gr,
  callback = function()
    local servers = vim
      .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
      :map(function(file) return vim.fn.fnamemodify(file, ':t:r') end)
      :totable()
    vim.lsp.enable(servers)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = Config.gr,
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end

    ---@param lhs string
    ---@param rhs string|function
    ---@param opts string|table
    ---@param mode? string|string[]
    local function keymap(lhs, rhs, opts, mode)
      opts = type(opts) == 'string' and { desc = opts }
        or vim.tbl_extend('error', opts --[[@as table]], { buffer = e.buf })
      mode = mode or 'n'
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    ---@param keys string
    local function feedkeys(keys)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
    end

    local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end

    if client:supports_method('textDocument/completion') then
      client.server_capabilities.completionProvider.triggerCharacters =
        vim.iter(vim.gsplit('a,e,i,o,u,A,E,I,O,U,.,:,-,_', ',')):totable()

      vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })

      keymap('<cr>', function() return pumvisible() and '<C-y>' or '<cr>' end, { expr = true }, 'i')

      keymap('<C-n>', function()
        if pumvisible() then
          feedkeys('<C-n>')
        else
          if next(vim.lsp.get_clients({ bufnr = 0 })) then
            vim.lsp.completion.get()
          else
            if vim.bo.omnifunc == '' then
              feedkeys('<C-x><C-n>')
            else
              feedkeys('<C-x><C-o>')
            end
          end
        end
      end, 'Trigger/select next completion', 'i')
    end

    keymap('<Tab>', function()
      if pumvisible() then
        feedkeys('<C-n>')
      else
        feedkeys('<Tab>')
      end
    end, {}, { 'i', 's' })

    keymap('<S-Tab>', function()
      if pumvisible() then
        feedkeys('<C-p>')
      else
        feedkeys('<S-Tab>')
      end
    end, {}, { 'i', 's' })
  end,
})

Config.set('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Open Current Diagnostic' })
Config.set('n', 'grD', '<Cmd>lua vim.diagnostic.setqflist()<CR>', { desc = 'vim.diagnostic.setqflist()' })
Config.set('n', 'grd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'vim.lsp.buf.definition()' })
