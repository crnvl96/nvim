local M = {}

function M.get_first_formatter(buffer, ...)
    local conform = require('conform')

    for i = 1, select('#', ...) do
        local formatter = select(i, ...)
        if conform.get_formatter_info(formatter, buffer).available then return formatter end
    end

    return select(1, ...)
end

return M
