if vim.fn.executable 'rg' then
    vim.opt.grepprg = table.concat({ 'rg', '-H', '--no-heading', '--vimgrep', '--glob=!.git/*' }, ' ')
    vim.opt.grepformat = '%f:%l:%c:%m'
end

vim.keymap.set('n', '<Leader>g', ':sil<space>grep!<space>', { desc = 'Grep' })
