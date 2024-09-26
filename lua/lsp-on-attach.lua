local M = {}

function M.setup(client, bufnr)
    vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

    local function toggle_inlayhints()
        local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
    end

    local definitions = vim.lsp.protocol.Methods.textDocument_definition
    local references = vim.lsp.protocol.Methods.textDocument_references
    local implementations = vim.lsp.protocol.Methods.textDocument_implementation
    local typeDefinition = vim.lsp.protocol.Methods.textDocument_typeDefinition
    local codeAction = vim.lsp.protocol.Methods.textDocument_codeAction
    local renameSymbol = vim.lsp.protocol.Methods.textDocument_rename
    local inlayHint = vim.lsp.protocol.Methods.textDocument_inlayHint

    local maps = {
        { definitions, 'grd', '<cmd>FzfLua lsp_definitions<cr>', 'Definitions' },
        { references, 'grr', '<cmd>FzfLua lsp_references<cr>', 'References' },
        { implementations, 'gri', '<cmd>FzfLua lsp_implementations<cr>', 'Implementations' },
        { typeDefinition, 'gry', '<cmd>FzfLua lsp_typedefs<cr>', 'Type Definitions' },
        { codeAction, 'gra', '<cmd>FzfLua lsp_code_actions<cr>', 'Code Actions' },
        { renameSymbol, 'grn', vim.lsp.buf.rename, 'Rename Symbol' },
        { inlayHint, '<leader>ci', toggle_inlayhints, 'Toggle Inlay Hints' },
    }

    for _, map in ipairs(maps) do
        if client.supports_method(map[1]) then
            vim.keymap.set('n', map[2], map[3], { desc = map[4], buffer = bufnr })
        end
    end
end

return M
