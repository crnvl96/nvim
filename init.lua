_G.Config = {}

vim.cmd.colorscheme('catppuccin')

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

local misc = require('mini.misc')

misc.setup()
misc.setup_auto_root()
misc.setup_restore_cursor()
misc.setup_termbg_sync()

Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely('event:' .. ev, f) end
Config.on_filetype = function(ft, f) misc.safely('filetype:' .. ft, f) end

Config.gr = vim.api.nvim_create_augroup('custom-config', {})

Config.on_packchanged = function(plugin_name, kinds, callback)
  local f = function(e)
    local name, kind = e.data.spec.name, e.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not e.data.active then vim.cmd.packadd(plugin_name) end
    callback(e)
  end
  vim.api.nvim_create_autocmd('PackChanged', { group = Config.gr, pattern = '*', callback = f })
end
