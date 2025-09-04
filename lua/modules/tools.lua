local U = require('utils')

---@class Tool
---@field name string Name of the tool
---@field install string command to install the tool
---@field update string command to update the tool

--- Get current version of a tool
---@async
---@param tool_name string
---@return string|nil
local function get_version(tool_name)
  local result = vim.system({ tool_name, '--version' }):wait()
  if result.code == 0 then return vim.trim(result.stdout) end
  return nil
end

--- Helper for installing external tools.
---@async
---@param tool Tool Tool to install
---@return nil
local function install(tool)
  if vim.fn.executable(tool.name) == 1 then return U.publish(tool.name .. ' already installed!') end
  local msg = ('Installing %s'):format(tool.name)
  U.publish(msg .. '...')
  local out = vim.system(vim.split(tool.install, ' '), { cwd = os.getenv('HOME') }):wait()
  if out.code == 0 then
    return U.publish(msg .. ' done!')
  else
    return U.publish(msg .. ' failed', 'ERROR')
  end
end

--- Update a tool and show version information
---@async
---@param tool Tool
---@return nil
local function update(tool)
  local current_version = get_version(tool.name)
  local msg = ('Updating %s'):format(tool.name)
  if current_version then
    U.publish(('%s (current: %s)'):format(msg, current_version))
  else
    U.publish(msg .. '...')
  end
  local out = vim.system(vim.split(tool.update, ' '), { cwd = os.getenv('HOME') }):wait()
  if out.code == 0 then
    local new_version = get_version(tool.name)
    if new_version then
      U.publish(('%s done! (new: %s)'):format(msg, new_version))
    else
      U.publish(msg .. ' done!')
    end
  else
    U.publish(msg .. ' failed', 'ERROR')
  end
end

---@type Tool[]
local tools = {
  --- uv managed tools
  {
    name = 'pyright',
    install = 'uv tool install pyright',
    update = 'uv tool install pyright',
  },
  {
    name = 'ruff',
    install = 'uv tool install ruff',
    update = 'uv tool upgrade ruff',
  },
  {
    name = 'pyproject-fmt',
    install = 'uv tool install pyproject-fmt',
    update = 'uv tool upgrade pyproject-fmt',
  },
  {
    name = 'pyrefly',
    install = 'uv tool install pyrefly',
    update = 'uv tool upgrade pyrefly',
  },
  --- mise managed tools
  {
    name = 'stylua',
    install = 'mise use -g stylua',
    update = 'mise upgrade --bump stylua',
  },
  {
    name = 'taplo',
    install = 'mise use -g taplo',
    update = 'mise upgrade --bump taplo',
  },
  {
    name = 'gofumpt',
    install = 'mise use -g gofumpt',
    update = 'mise upgrade --bump gofumpt',
  },
  {
    name = 'prettier',
    install = 'mise use -g prettier',
    update = 'mise upgrade --bump prettier',
  },
  {
    name = 'jq',
    install = 'mise use -g jq',
    update = 'mise upgrade --bump jq',
  },
  {
    name = 'dprint',
    install = 'mise use -g dprint',
    update = 'mise upgrade --bump dprint',
  },
  {
    name = 'lua-language-server',
    install = 'mise use -g lua-language-server',
    update = 'mise upgrade --bump lua-language-server',
  },
  --- npm managed tools
  {
    name = 'vscode-json-language-server',
    install = 'npm i -g vscode-langservers-extracted',
    update = 'npm i vscode-langservers-extracted@latest',
  },
  {
    name = 'vscode-css-language-server',
    install = 'npm i -g vscode-langservers-extracted',
    update = 'npm i vscode-langservers-extracted@latest',
  },
  {
    name = 'vscode-eslint-language-server',
    install = 'npm i -g vscode-langservers-extracted',
    update = 'npm i vscode-langservers-extracted@latest',
  },
  {
    name = 'typescript-language-server',
    install = 'npm i -g typescript-language-server',
    update = 'npm i typescript-language-server@latest',
  },
  {
    name = 'yaml-language-server',
    install = 'npm i -g yaml-language-server',
    update = 'npm i yaml-language-server@latest',
  },
  --- go managed tools
  {
    name = 'gopls',
    install = 'go install golang.org/x/tools/gopls@latest',
    update = 'go install golang.org/x/tools/gopls@latest',
  },
  --- cargo managed tools
  {
    name = 'bacon',
    install = 'cargo install --locked bacon',
    update = 'cargo install --force --locked bacon',
  },
  {
    name = 'bacon-ls',
    install = 'cargo install --locked bacon-ls',
    update = 'cargo install --force --locked bacon-ls',
  },
}

vim.api.nvim_create_user_command('ToolInstall', function()
  for _, tool in ipairs(tools) do
    install(tool)
  end
end, { desc = 'Update all external tools with version information' })

vim.api.nvim_create_user_command('ToolUpdate', function()
  for _, tool in ipairs(tools) do
    update(tool)
  end
end, { desc = 'Update all external tools with version information' })
