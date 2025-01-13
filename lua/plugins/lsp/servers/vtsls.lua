return {
  root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'package.json' }) end,
  single_file_support = false,
}
