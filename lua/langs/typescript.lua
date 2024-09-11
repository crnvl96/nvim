local tools = require('config.tools')

tools.servers.gopls = {}
tools.servers.eslint = { settings = { format = false } }

vim.list_extend(tools.ts_parsers, { 'javascript', 'typescript' })

vim.list_extend(tools.formatters, { 'prettierd' })

tools.conform_by_ft.javascript = { 'prettierd', 'prettier', stop_after_first = true }
tools.conform_by_ft.typescript = { 'prettierd', 'prettier', stop_after_first = true }
tools.conform_by_ft.javascriptreact = { 'prettierd', 'prettier', stop_after_first = true }
tools.conform_by_ft.typescriptreact = { 'prettierd', 'prettier', stop_after_first = true }
tools.conform_by_ft['javascript.jsx'] = { 'prettierd', 'prettier', stop_after_first = true }
tools.conform_by_ft['typescript.tsx'] = { 'prettierd', 'prettier', stop_after_first = true }
