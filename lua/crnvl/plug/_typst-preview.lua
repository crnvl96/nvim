vim.pack.add({
  'https://github.com/chomosuke/typst-preview.nvim',
})

require('typst-preview').setup({
  dependencies_bin = {
    ['tinymist'] = 'tinymist',
    ['websocat'] = nil,
  },
})

vim.api.nvim_create_user_command('TypstPreviewOpenThisPdf', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath:match('%.typ$') then
    local pdf_path = filepath:gsub('%.typ$', '.pdf')
    vim.system({ 'xdg-open', pdf_path })
  end
end, {})
