---@diagnostic disable: undefined-global

local ltr = MiniDeps.later

ltr(function()
    vim.diagnostic.config {
        signs = {
            priority = 9999,
            severity = {
                min = vim.diagnostic.severity.HINT,
                max = vim.diagnostic.severity.ERROR,
            },
        },
        underline = {
            severity = {
                min = vim.diagnostic.severity.HINT,
                max = vim.diagnostic.severity.ERROR,
            },
        },
        virtual_text = {
            current_line = true,
            severity = {
                min = vim.diagnostic.severity.ERROR,
                max = vim.diagnostic.severity.ERROR,
            },
        },
        virtual_lines = false,
        update_in_insert = false,
    }
end)
