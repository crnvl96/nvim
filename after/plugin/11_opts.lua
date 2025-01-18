_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function() Snacks.debug.backtrace() end

vim.print = _G.dd

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
