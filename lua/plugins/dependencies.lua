local deps = require('mini.deps')
local add = deps.add

add('nvim-neotest/nvim-nio')
add('nvim-lua/plenary.nvim')
add({ source = 'williamboman/mason.nvim', hooks = { post_checkout = function() vim.cmd('MasonUpdate') end } })
add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_checkout = function() vim.cmd('TSUpdate') end } })

local visits = require('mini.visits')
visits.setup()

local miniextra = require('mini.extra')
miniextra.setup()

local mason = require('mason')
mason.setup()

local ensure_installed = {
    'stylua',
    'prettierd',
    'js-debug-adapter',
    'debugpy',
    'black',
}

local mason_registry = require('mason-registry')
mason_registry.refresh(function()
    for _, tool in ipairs(ensure_installed) do
        local pkg = mason_registry.get_package(tool)
        if not pkg:is_installed() then pkg:install() end
    end
end)

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
