local n = require('utils.notification')

---@class Tool
---@field name string Name of the tool
---@field cmd string command to install the tool

---@type Tool[]
local tools = {
  {
    name = 'pyright',
    cmd = 'uv tool install pyright',
  },
  {
    name = 'ruff',
    cmd = 'uv tool install ruff',
  },
  {
    name = 'pyproject-fmt',
    cmd = 'uv tool install pyproject-fmt',
  },
  {
    name = 'stylua',
    cmd = 'mise use -g stylua',
  },
  {
    name = 'taplo',
    cmd = 'mise use -g taplo',
  },
  {
    name = 'gofumpt',
    cmd = 'mise use -g gofumpt',
  },
  {
    name = 'prettier',
    cmd = 'mise use -g prettier',
  },
  {
    name = 'biome',
    cmd = 'mise use -g biome',
  },
  {
    name = 'jq',
    cmd = 'mise use -g jq',
  },
  {
    name = 'lua-language-server',
    cmd = 'mise use -g lua-language-server',
  },
  {
    name = 'vscode-json-language-server',
    cmd = 'npm i -g vscode-langservers-extracted',
  },
  {
    name = 'vscode-css-language-server',
    cmd = 'npm i -g vscode-langservers-extracted',
  },
  {
    name = 'vscode-eslint-language-server',
    cmd = 'npm i -g vscode-langservers-extracted',
  },
  {
    name = 'typescript-language-server',
    cmd = 'npm install -g typescript-language-server',
  },
  {
    name = 'tailwindcss-language-server',
    cmd = 'npm install -g @tailwindcss/language-server',
  },
  {
    name = 'yaml-language-server',
    cmd = 'npm i -g yaml-language-server',
  },
  {
    name = 'gopls',
    cmd = 'go install golang.org/x/tools/gopls@latest',
  },
  {
    name = 'bacon',
    cmd = 'cargo install --locked bacon',
  },
  {
    name = 'bacon-ls',
    cmd = 'cargo install --locked bacon-ls',
  },
}

--- Helper for installing external tools.
---@async
---@param tool Tool Tool to install
---@return nil
local function install(tool)
  if vim.fn.executable(tool.name) == 1 then return end
  local msg = string.format('Installing %s', tool.name)
  n.publish(msg .. '...')
  local out = vim.system(vim.split(tool.cmd, ' '), { cwd = os.getenv('HOME') }):wait()

  if out.code == 0 then
    return n.publish(msg .. ' done!')
  else
    return n.publish(msg .. ' failed', 'ERROR')
  end
end

for _, tool in ipairs(tools) do
  install(tool)
end
