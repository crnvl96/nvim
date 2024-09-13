require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'c',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
        'go',
        'gomod',
        'gosum',
        'gowork',
        'javascript',
        'typescript',
        'lua',
        'html',
    },
    highlight = {
        enable = true,
        disable = function(_, buf)
            if not vim.bo[buf].modifiable then return false end
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > vim.g.bigfile_size
        end,
    },
    indent = {
        enable = true,
    },
    incremental_selection = {
        enable = false,
    },
})
