---@diagnostic disable: undefined-global

local ltr = MiniDeps.later

local set = vim.keymap.set

local function feedkeys(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

local function pumvisible()
    return tonumber(vim.fn.pumvisible()) ~= 0
end

local navigate_completion_candidate = function(command)
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

ltr(function()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('crnvl96-on-lspattach', {}),
        callback = function(e)
            local client = vim.lsp.get_client_by_id(e.data.client_id)

            if not client then
                return
            end

            if client:supports_method 'textDocument/completion' then
                vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })

                local choose_completion_candidate = function()
                    return pumvisible() and '<C-y>' or '<CR>'
                end

                set('i', '<CR>', choose_completion_candidate, { expr = true })

                local navigate_completion_candidate_next = function()
                    navigate_completion_candidate '<C-n>'
                end

                set('i', '<C-n>', navigate_completion_candidate_next)
                set('i', '<Tab>', navigate_completion_candidate_next)

                local navigate_completion_candidate_prev = function()
                    navigate_completion_candidate '<C-p>'
                end

                set('i', '<C-p>', navigate_completion_candidate_prev)
                set('i', '<S-Tab>', navigate_completion_candidate_prev)
            end
        end,
    })
end)
