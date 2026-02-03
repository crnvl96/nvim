MiniDeps.now(function()
    vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('crnvl96-highlight-on-yank', { clear = true }),
        callback = function()
            vim.highlight.on_yank()
        end,
    })

    vim.api.nvim_create_autocmd('QuickFixCmdPost', {
        group = vim.api.nvim_create_augroup('crnvl96-auto-open-qf', { clear = true }),
        pattern = { '[^l]*' },
        command = 'cwindow',
    })

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('crnvl96-on-lspattach', { clear = true }),
        callback = function(e)
            local client = vim.lsp.get_client_by_id(e.data.client_id)
            local bufnr = e.buf

            if not client then
                return
            end

            local function feedkeys(keys)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
            end

            local function pumvisible()
                return tonumber(vim.fn.pumvisible()) ~= 0
            end

            local function navigate_completion_candidate(command)
                if pumvisible() then
                    feedkeys(command)
                else
                    if next(vim.lsp.get_clients { bufnr = 0 }) then
                        vim.lsp.completion.get()
                    else
                        if vim.bo.omnifunc == '' then
                            feedkeys('<C-x>' .. command)
                        else
                            feedkeys '<C-x><C-o>'
                        end
                    end
                end
            end

            ---@param lhs string
            ---@param rhs string|function
            ---@param opts string|vim.keymap.set.Opts
            ---@param mode? string|string[]
            local function keymap(lhs, rhs, opts, mode)
                mode = mode or 'n'
                ---@cast opts vim.keymap.set.Opts
                opts = type(opts) == 'string' and { desc = opts } or opts
                opts.buffer = bufnr
                vim.keymap.set(mode, lhs, rhs, opts)
            end

            keymap('[e', function()
                vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
            end, 'Previous error')

            keymap(']e', function()
                vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
            end, 'Next error')

            if client:supports_method 'textDocument/documentColor' then
                vim.lsp.document_color.enable(true, bufnr)
            end

            if client:supports_method 'textDocument/references' then
                keymap('grr', '<cmd>FzfLua lsp_references<cr>', 'vim.lsp.buf.references()')
            end

            if client:supports_method 'textDocument/typeDefinition' then
                keymap('gi', '<cmd>FzfLua lsp_implementations<cr>', 'Implementations')
            end

            if client:supports_method 'textDocument/implementation' then
                keymap('gy', '<cmd>FzfLua lsp_typedefs<cr>', 'Go to type definition')
            end

            if client:supports_method 'textDocument/documentSymbol' then
                keymap('gs', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document symbols')
                keymap('gS', '<cmd>FzfLua lsp_workspace_symbols<cr>', 'Workspace symbols')
            end

            if client:supports_method 'textDocument/definition' then
                keymap('gd', function()
                    require('fzf-lua').lsp_definitions { jump1 = true }
                end, 'Go to definition')

                keymap('gD', function()
                    require('fzf-lua').lsp_definitions { jump1 = false }
                end, 'Peek definition')
            end

            if client:supports_method 'textDocument/signatureHelp' then
                keymap('<C-k>', function()
                    vim.lsp.buf.signature_help()
                end, 'Signature help', 'i')
            end

            if client:supports_method 'textDocument/documentHighlight' then
                local under_cursor_highlights_group =
                    vim.api.nvim_create_augroup('crnvl96-cursor-highlight', { clear = false })

                vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
                    group = under_cursor_highlights_group,
                    desc = 'Highlight references under the cursor',
                    buffer = bufnr,
                    callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
                    group = under_cursor_highlights_group,
                    desc = 'Clear highlight references',
                    buffer = bufnr,
                    callback = vim.lsp.buf.clear_references,
                })
            end

            if client:supports_method 'textDocument/completion' then
                vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

                local choose_completion_candidate = function()
                    return pumvisible() and '<C-y>' or '<CR>'
                end

                keymap('<CR>', choose_completion_candidate, { expr = true }, 'i')

                local navigate_completion_candidate_next = function()
                    navigate_completion_candidate '<C-n>'
                end

                keymap('<C-n>', navigate_completion_candidate_next, {}, 'i')
                keymap('<Tab>', navigate_completion_candidate_next, {}, 'i')

                local navigate_completion_candidate_prev = function()
                    navigate_completion_candidate '<C-p>'
                end

                keymap('<C-p>', navigate_completion_candidate_prev, {}, 'i')
                keymap('<S-Tab>', navigate_completion_candidate_prev, {}, 'i')
            end
        end,
    })
end)
