---@class Util.Formater
local M = {}

---@param bufnr number current loaded buffer
---@param root_markers string|string[] files that mark the project root
---@param fallback? boolean fallback behavior if a root isn't found
function M.root_file(bufnr, root_markers, fallback)
    local root = vim.fs.root(bufnr, root_markers)
    if fallback and not root then root = vim.fn.getcwd() end
    return root
end

--- Checks if formatting can be applied, and triggers it
---@param bufnr number the current loaded buffer
function M.format_if_able(bufnr)
    if not vim.g.autoformat then return nil end

    require('conform').format { bufnr = bufnr }

    vim.diagnostic.setloclist {
        open = true,
        severity = {
            min = vim.diagnostic.severity.WARN,
            max = vim.diagnostic.severity.ERROR,
        },
        format = function(d)
            -- For now we only want to override the formatting of Ruff's diagnostics
            -- The information about the diagnostic's source can be retrieved by the
            -- function |:h vim.diagnostic.get()|
            --
            -- We normally wrap it inside MiniMisc.put_text(), so that the diagnostic
            -- can be echoed in a buffer for us to better interpret it
            if d.source ~= 'Ruff' then return d.message end
            local href = d.user_data.lsp and d.user_data.lsp.codeDescription and d.user_data.lsp.codeDescription.href
            if href then return ('%s - [%s] (%s)'):format(d.message, d.code, d.user_data.lsp.codeDescription.href) end
            return ('%s - [%s]'):format(d.message, d.code)
        end,
    }
end

--- Handle preformat logic
---@param clients vim.lsp.Client[] list of attached lsp clients
---@param bufnr number current buffer
function M.preformat_ts_ls(clients, bufnr)
    local client = vim.iter(clients):find(
        ---@param i vim.lsp.Client
        function(i) return i.name == 'ts_ls' end
    )

    if client then
        local request_result = client:request_sync('workspace/executeCommand', {
            command = '_typescript.organizeImports',
            arguments = { vim.api.nvim_buf_get_name(bufnr) },
        })

        if request_result and request_result.err then
            vim.notify(request_result.err.message, vim.log.levels.ERROR)
            return
        end
    end
end

return M
