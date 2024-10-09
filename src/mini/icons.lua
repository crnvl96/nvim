local icons = require('mini.icons')

local function use_file_extension(ext, _)
    local suf3, suf4 = ext:sub(-3), ext:sub(-4)
    return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
end

icons.setup({ use_file_extension = use_file_extension })

MiniIcons.mock_nvim_web_devicons()
MiniDeps.later(MiniIcons.tweak_lsp_kind)
