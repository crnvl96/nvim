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

            if not client then
                return
            end

            vim.keymap.set('n', '[e', function()
                vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
            end, { buffer = e.buf })

            vim.keymap.set('n', ']e', function()
                vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
            end, { buffer = e.buf })

            vim.keymap.set('n', 'K', function()
                vim.lsp.buf.hover()
            end, { buffer = e.buf })

            vim.keymap.set('n', 'E', function()
                vim.diagnostic.open_float()
            end, { buffer = e.buf })

            if client:supports_method 'textDocument/documentColor' then
                vim.lsp.document_color.enable(true, e.buf)
            end

            if client:supports_method 'textDocument/references' then
                vim.keymap.set('n', 'grr', function()
                    require('fzf-lua').lsp_references()
                end, { buffer = e.buf })
            end

            if client:supports_method 'textDocument/codeAction' then
                vim.keymap.set('n', 'gra', function()
                    require('fzf-lua').lsp_code_actions {
                        winopts = {
                            width = 70,
                            height = 20,
                            relative = 'cursor',
                        },
                    }
                end, { buffer = e.buf })
            end

            if client:supports_method 'textDocument/typeDefinition' then
                vim.keymap.set('n', 'grt', function()
                    require('fzf-lua').lsp_typedefs()
                end, { buffer = e.buf })
            end

            if client:supports_method 'textDocument/implementation' then
                vim.keymap.set('n', 'gi', function()
                    require('fzf-lua').lsp_implementations()
                end, { buffer = e.buf })
            end

            if client:supports_method 'textDocument/documentSymbol' then
                vim.keymap.set('n', 'gs', function()
                    require('fzf-lua').lsp_document_symbols()
                end, { buffer = e.buf })
            end

            if client:supports_method 'workspace/symbol' then
                vim.keymap.set('n', 'gs', function()
                    require('fzf-lua').lsp_workspace_symbols()
                end, { buffer = e.buf })
            end

            if client:supports_method 'textDocument/definition' then
                vim.keymap.set('n', 'gd', function()
                    require('fzf-lua').lsp_definitions { jump1 = true }
                end, { buffer = e.buf })

                vim.keymap.set('n', 'gD', function()
                    require('fzf-lua').lsp_definitions { jump1 = false }
                end, { buffer = e.buf })
            end

            if client:supports_method 'textDocument/signatureHelp' then
                vim.keymap.set('i', '<C-k>', function()
                    vim.lsp.buf.signature_help()
                end, { buffer = e.buf })
            end

            if client:supports_method 'textDocument/documentHighlight' then
                local under_cursor_highlights_group =
                    vim.api.nvim_create_augroup('crnvl96-cursor-highlight', { clear = false })

                vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
                    group = under_cursor_highlights_group,
                    buffer = e.buf,
                    callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
                    group = under_cursor_highlights_group,
                    buffer = e.buf,
                    callback = vim.lsp.buf.clear_references,
                })
            end

            if client:supports_method 'textDocument/completion' then
                vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })

                vim.keymap.set('i', '<CR>', function()
                    return tonumber(vim.fn.pumvisible()) ~= 0 and '<C-y>' or '<CR>'
                end, { expr = true, buffer = e.buf })

                vim.keymap.set('i', '<C-n>', function()
                    if tonumber(vim.fn.pumvisible()) ~= 0 then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n', true, false, true), 'n', true)
                    else
                        if next(vim.lsp.get_clients { bufnr = 0 }) then
                            vim.lsp.completion.get()
                        else
                            if vim.bo.omnifunc == '' then
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes('<C-x><C-n>', true, false, true),
                                    'n',
                                    true
                                )
                            else
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true),
                                    'n',
                                    true
                                )
                            end
                        end
                    end
                end, { buffer = e.buf })

                vim.keymap.set('i', '<Tab>', function()
                    if tonumber(vim.fn.pumvisible()) ~= 0 then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n', true)
                    else
                        if next(vim.lsp.get_clients { bufnr = 0 }) then
                            vim.lsp.completion.get()
                        else
                            if vim.bo.omnifunc == '' then
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes('<C-x><C-n>', true, false, true),
                                    'n',
                                    true
                                )
                            else
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true),
                                    'n',
                                    true
                                )
                            end
                        end
                    end
                end, { buffer = e.buf })

                vim.keymap.set('i', '<C-p>', function()
                    if tonumber(vim.fn.pumvisible()) ~= 0 then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, false, true), 'n', true)
                    else
                        if next(vim.lsp.get_clients { bufnr = 0 }) then
                            vim.lsp.completion.get()
                        else
                            if vim.bo.omnifunc == '' then
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes('<C-x><C-p>', true, false, true),
                                    'n',
                                    true
                                )
                            else
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true),
                                    'n',
                                    true
                                )
                            end
                        end
                    end
                end, { buffer = e.buf })

                vim.keymap.set('i', '<S-Tab>', function()
                    if tonumber(vim.fn.pumvisible()) ~= 0 then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, false, true), 'n', true)
                    else
                        if next(vim.lsp.get_clients { bufnr = 0 }) then
                            vim.lsp.completion.get()
                        else
                            if vim.bo.omnifunc == '' then
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes('<C-x><C-p>', true, false, true),
                                    'n',
                                    true
                                )
                            else
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true),
                                    'n',
                                    true
                                )
                            end
                        end
                    end
                end, { buffer = e.buf })
            end
        end,
    })
end)
