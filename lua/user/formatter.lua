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

vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.autoformat = true

require('conform').setup {
    notify_on_error = false,
    notify_no_formatters = false,
    default_format_opts = {
        lsp_format = 'fallback',
        timeout_ms = 1000,
    },
    formatters = {
        stylua = { require_cwd = true },
        prettier = { require_cwd = true },
        injected = { ignore_errors = true },
    },
    formatters_by_ft = {
        go = { 'gofumpt' },
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        python = { 'ruff', 'ruff_organize_imports', 'ruff_fix' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        less = { 'prettierd' },
        lua = { 'stylua' },
        markdown = { 'prettierd', 'injected', timeout_ms = 1500 },
        css = { 'prettierd' },
        scss = { 'prettierd' },
        yaml = { 'prettierd' },
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
    },
    format_on_save = function()
        if not vim.g.autoformat then return nil end
        return {}
    end,
}

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function(e)
        local clients = vim.lsp.get_clients { bufnr = e.buf }
        if #clients == 0 then
            M.format_if_able(e.buf)
            return
        end
        M.preformat_ts_ls(clients, e.buf)
        M.format_if_able(e.buf)
    end,
})

--- Toggle autoformatting
vim.api.nvim_create_user_command('FmtToggle', function() vim.g.autoformat = not vim.g.autoformat end, {})

--- Manual format
vim.api.nvim_create_user_command('Fmt', function() M.format_if_able(vim.api.nvim_get_current_buf()) end, {})
