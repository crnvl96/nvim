local M = {}

function M.setup()
    local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
    vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if not client then return end
        require('lsp-on-attach').setup(client, vim.api.nvim_get_current_buf())
        return registerCapability(err, res, ctx)
    end
end

return M
