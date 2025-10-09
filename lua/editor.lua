MiniMisc.setup_restore_cursor()
MiniMisc.setup_auto_root()

vim.keymap.set('n', 'L', MiniMisc.zoom)

--- @want?
---
--- This is messing a bit with the wildow layout of other plugins
--- Maybe a manual trigger is better
---
-- vim.api.nvim_create_autocmd('WinEnter', {
--     callback = function()
--         local win = vim.api.nvim_get_current_win()
--         local threshold = 80
--         if vim.api.nvim_win_get_width(win) < threshold then MiniMisc.resize_window(win, threshold) end
--     end,
-- })
