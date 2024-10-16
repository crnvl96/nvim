local toggle_inc_selection_group = vim.api.nvim_create_augroup('Crnvl96ToggleIncSelection', { clear = true })

vim.api.nvim_create_autocmd('CmdwinEnter', {
    desc = 'Disable incremental selection when entering the cmdline window',
    group = toggle_inc_selection_group,
    command = 'TSBufDisable incremental_selection',
})

vim.api.nvim_create_autocmd('CmdwinLeave', {
    desc = 'Enable incremental selection when leaving the cmdline window',
    group = toggle_inc_selection_group,
    command = 'TSBufEnable incremental_selection',
})

require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'bash',
        'c',
        'gitcommit',
        'html',
        'javascript',
        'json',
        'json5',
        'jsonc',
        'lua',
        'markdown',
        'markdown_inline',
        'query',
        'regex',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
    },
    highlight = {
        enable = true,
        disable = function(_, buf)
            if not vim.bo[buf].modifiable then return false end
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > (250 * 1024)
        end,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<cr>',
            node_incremental = '<cr>',
            scope_incremental = false,
            node_decremental = '<bs>',
        },
    },
    indent = { enable = true },
})
