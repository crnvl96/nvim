vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/colorscheme_fix', {}),
    callback = function()
        vim.api.nvim_set_hl(0, 'Flovim.api.nvim_set_hlatBorder', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })

        vim.cmd('highlight Winbar guibg=none')
    end,
})

local fox = require('nightfox')
fox.setup({ options = { transparent = true } })
vim.cmd('colorscheme nordfox')

local icons = require('mini.icons')
icons.setup()
icons.mock_nvim_web_devicons()

local mason = require('mason')
mason.setup()

local ensure_installed = {}
vim.list_extend(ensure_installed, vim.tbl_keys(require('tools').servers))
vim.list_extend(ensure_installed, require('tools').formatters)
vim.list_extend(ensure_installed, require('tools').debuggers)

local mts = require('mason-tool-installer')
mts.setup({
    ensure_installed = ensure_installed,
})

local misc = require('mini.misc')
misc.setup_restore_cursor({ center = true })
misc.setup_termbg_sync()
vim.keymap.set('n', '<c-w>z', misc.zoom, { desc = 'zoom' })

local tabline = require('mini.tabline')
tabline.setup()

local bufremove = require('mini.bufremove')
bufremove.setup()
vim.keymap.set('n', '<leader>bc', function() require('mini.bufremove').delete(0, false) end, { desc = 'delete buffer' })
vim.keymap.set('n', '<leader>bo', function()
    local bcur = vim.api.nvim_get_current_buf()
    local blist = vim.api.nvim_list_bufs()

    for _, buf in ipairs(blist) do
        if buf ~= bcur then require('mini.bufremove').delete(buf, true) end
    end

    vim.cmd('redraw!')
end, { desc = 'delete other buffers' })
