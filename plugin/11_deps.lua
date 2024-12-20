for _, cli in ipairs({
  'zathura', -- pdf viewer
  'tex-fmt', -- LaTex formatter
  'tree-sitter', -- Treesitter cli
  'rg', -- MiniPick
  'rustc', -- blink.cmp (needs rustc nightly)
  'npm', -- markdown-preview
}) do
  if vim.fn.executable(cli) ~= 1 then
    vim.notify(cli .. ' is not installed in the system.', vim.log.levels.ERROR)
    return
  end
end
