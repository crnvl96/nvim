local function build_cargo(p)
  vim.notify('Building ' .. p.name, vim.log.levels.INFO)
  local cmd = { 'cargo', '+nightly', 'build', '--release' }
  local opts = { cwd = p.path }
  local obj = vim.system(cmd, opts):wait()
  if obj.code == 0 then
    vim.notify('Done!', vim.log.levels.INFO)
  else
    vim.notify('A Fail occurred!', vim.log.levels.ERROR)
  end
end

MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'main',
  hooks = {
    post_checkout = function() vim.cmd('TSUpdate') end,
  },
})

MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter-textobjects',
  checkout = 'main',
})

MiniDeps.add({
  source = 'Saghen/blink.cmp',
  hooks = {
    post_install = build_cargo,
    post_checkout = build_cargo,
  },
})

MiniDeps.add({
  source = 'dmtrKovalenko/fff.nvim',
  hooks = {
    post_install = build_cargo,
    post_checkout = build_cargo,
  },
})

MiniDeps.add({ source = 'neovim/nvim-lspconfig' })
MiniDeps.add({ source = 'b0o/SchemaStore.nvim' })
MiniDeps.add({ source = 'stevearc/conform.nvim' })
MiniDeps.add({ source = 'tpope/vim-sleuth' })
MiniDeps.add({ source = 'tpope/vim-fugitive' })
MiniDeps.add({ source = 'MagicDuck/grug-far.nvim' })
MiniDeps.add({ source = 'stevearc/quicker.nvim' })
