-- add({
--   source = 'nvim-treesitter/nvim-treesitter',
--   checkout = 'main',
--   hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
-- })

local ensure_installed = {
    'html',
    'css',

    'go',
    'python',

    'diff',
    'bash',
    'json',
    'regex',
    'toml',
    'yaml',
    'markdown',

    'javascript',
    'jsx',
    'typescript',
    'tsx',
}

local to_install = vim.tbl_filter(function(lang)
    local has_parser = vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false)
    return #has_parser == 0
end, ensure_installed)

if #to_install > 0 then require('nvim-treesitter').install(to_install) end

-- Ensure enabled
vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable(),
    callback = function(e)
        vim.treesitter.start(e.buf)
        local win = vim.api.nvim_get_current_win()
        vim.wo[win].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo[e.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

-- Disable injections in 'lua' language
local ts_query = require 'vim.treesitter.query'
local ts_query_set = vim.fn.has 'nvim-0.9' == 1 and ts_query.set or ts_query.set_query
ts_query_set('lua', 'injections', '')
