local U = require('utils')

local node_version_cmd = "mise ls --cd ~ | grep '^node' | grep '22\\.' | head -n 1 | awk '{print $2}'"
local function node_bin(v) return os.getenv('HOME') .. '/.local/share/mise/installs/node/' .. v .. '/bin/' end

local version = vim.fn.system(node_version_cmd):gsub('\n', '')
if version == '' then
  U.publish('Could not determine Node.js version', vim.log.levels.WARN)
else
  local bin = node_bin(version)
  vim.g.node_host_prog = bin .. 'node'
  vim.env.PATH = bin .. ':' .. vim.env.PATH
end
