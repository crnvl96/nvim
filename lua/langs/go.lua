local tools = require('config.tools')

tools.servers.gopls = { settings = { gopls = { gofumpt = true } } }

vim.list_extend(tools.ts_parsers, { 'go', 'gomod', 'gosum' })

vim.list_extend(tools.formatters, { 'gofumpt', 'goimports', 'golines', 'staticcheck' })

tools.conform_by_ft.go = { 'gofumpt', 'goimports', 'golines' }

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/go_opts', {}),
    pattern = { 'go' },
    callback = function()
        vim.cmd('setlocal shiftwidth=4 tabstop=4')
        vim.cmd('TSDisable indent')
    end,
})
