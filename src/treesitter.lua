MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

local parsers = {
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
}

local function handle_buf_highlight(_, bufnr)
    if not vim.bo[bufnr].modifiable then return false end
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    return ok and stats and stats.size > vim.g.bigfile_size
end

require('nvim-treesitter.configs').setup({
    ensure_installed = parsers,
    highlight = { enable = true, disable = handle_buf_highlight },
    indent = { enable = true },
    incremental_selection = { enable = false },
})
