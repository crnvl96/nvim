local deps = require('mini.deps')
local add = deps.add

add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

local treesitter_configs = require('nvim-treesitter.configs')
treesitter_configs.setup({
    ensure_installed = {
        'c',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
        'lua',
        'javascript',
        'typescript',
        'python',
        'ninja',
        'rst',
    },
    highlight = {
        enable = true,
        disable = function(_, buf)
            if not vim.bo[buf].modifiable then return false end
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > vim.g.bigfile_size
        end,
    },
    indent = { enable = true },
    incremental_selection = { enable = false },
})
