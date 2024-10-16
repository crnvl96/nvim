MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = {
        post_checkout = function() vim.cmd('TSUpdate') end,
    },
})

require('nvim-treesitter.configs').setup({
    -- stylua: ignore
    ensure_installed = { 'bash', 'c', 'gitcommit', 'html', 'javascript', 'json', 'json5', 'jsonc', 'lua',
    'markdown', 'markdown_inline', 'query', 'regex', 'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'yaml', },
    auto_install = true,
    indent = { enable = true },
    highlight = {
        enable = true,
        disable = function(_, buf)
            if not vim.bo[buf].modifiable then return false end
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > (250 * 1024)
        end,
    },
})
