local add = MiniDeps.add
local tools = require('config.tools')

add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_update = function() vim.cmd('TSUpdate') end } })

require('nvim-treesitter.configs').setup({
    ensure_installed = tools.ts_parsers,
    highlight = {
        enable = true,
        disable = function(_, buf)
            if not vim.bo[buf].modifiable then return false end
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > vim.g.bigfile_size
        end,
    },
    indent = { enable = true },
})

local group = vim.api.nvim_create_augroup(vim.g.whoami .. '/toggle_inc_selection', {})

vim.api.nvim_create_autocmd('CmdwinEnter', {
    group = group,
    command = 'TSBufDisable incremental_selection',
})

vim.api.nvim_create_autocmd('CmdwinLeave', {
    group = group,
    command = 'TSBufEnable incremental_selection',
})
