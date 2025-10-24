local config_path
local sysname = vim.uv.os_uname().sysname
local root_dir = vim.fs.root(0, { 'gradlew', '.git' })
local jar_path = vim.fn.glob(vim.env.HOME .. '/.jdtls/plugins/org.eclipse.equinox.launcher_*.jar')
local project_name = root_dir and vim.fs.basename(root_dir)

local common_args = {
  'java',
  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  '-Dosgi.bundles.defaultStartLevel=4',
  '-Declipse.product=org.eclipse.jdt.ls.core.product',
  '-Dlog.protocol=true',
  '-Dlog.level=ALL',
  '-Xmx1g',
  '--add-modules=ALL-SYSTEM',
  '--add-opens',
  'java.base/java.util=ALL-UNNAMED',
  '--add-opens',
  'java.base/java.lang=ALL-UNNAMED',
}

if sysname == 'Linux' then
  config_path = vim.env.HOME .. '/.jdtls/config_linux'
elseif sysname == 'Darwin' then
  config_path = vim.env.HOME .. '/.jdtls/config_mac_arm'
end

local cmd = vim.list_extend(common_args, { '-jar', jar_path, '-configuration', config_path })

vim.list_extend(cmd, { '-data', vim.fn.stdpath 'cache' .. '/jdtls/' .. project_name .. '/workspace' })

require('jdtls').start_or_attach {
  cmd = cmd,
  root_dir = root_dir,
  settings = {
    java = {
      inlayHints = {
        parameterNames = { enabled = 'all' },
      },
    },
  },
}
