require('mini.hues').setup({
    background = '#0F111A',
    foreground = '#A6ACCD',
    n_hues = 8,
    saturation = 'medium',
})

require('mini.icons').setup({
    use_file_extension = function(ext, _)
        local suf3, suf4 = ext:sub(-3), ext:sub(-4)
        return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
})

require('mini.icons').mock_nvim_web_devicons()

MiniDeps.later(require('mini.icons').tweak_lsp_kind)

vim.o.background = 'dark'
