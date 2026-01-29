---@diagnostic disable: undefined-global

vim.opt_local.winbar = '%f'

local function refresh_netrw() vim.cmd(':Ex ' .. vim.b.netrw_curdir) end

vim.keymap.set('n', 'mc', function()
  local target_dir = vim.b.netrw_curdir
  local file_list = vim.fn['netrw#Expose'] 'netrwmarkfilelist'
  if #file_list > 0 then
    for _, node in pairs(file_list) do
      vim.uv.fs_copyfile(
        node,
        target_dir .. '/' .. vim.fs.basename(node),
        { excl = true, ficlone = true, ficlone_force = true }
      )
    end
    refresh_netrw()
    vim.cmd [[ call netrw#Modify("netrwmarkfilelist",[]) ]]
  end
end, { remap = true, buffer = true })

vim.keymap.set('n', 'mm', function()
  local target_dir = vim.b.netrw_curdir
  local file_list = vim.fn['netrw#Expose'] 'netrwmarkfilelist'
  if #file_list > 0 then
    for _, node in pairs(file_list) do
      local file_name = vim.fs.basename(node)
      local target_exists = vim.uv.fs_access(target_dir .. '/' .. file_name, 'W')
      if not target_exists then
        vim.uv.fs_rename(node, target_dir .. '/' .. file_name)
      else
        print("File '" .. file_name .. "' already exists! Skipping...")
      end
    end
    refresh_netrw()
    vim.cmd [[ call netrw#Modify("netrwmarkfilelist",[]) ]]
  end
end, { remap = true, buffer = true })

vim.keymap.set('n', 'R', function()
  local original_file_path = vim.b.netrw_curdir .. '/' .. vim.fn['netrw#Call'] 'NetrwGetWord'
  vim.ui.input(
    { prompt = 'Move/rename to:', default = original_file_path, completion = 'file' },
    function(target_file_path)
      if target_file_path and target_file_path ~= '' then
        local file_exists = vim.uv.fs_access(target_file_path, 'W')
        if not file_exists then
          vim.uv.fs_rename(original_file_path, target_file_path)
          if Snacks then Snacks.rename.on_rename_file(original_file_path, target_file_path) end
        else
          vim.notify("File '" .. target_file_path .. "' already exists! Skipping...", vim.log.levels.ERROR)
        end
        refresh_netrw()
      end
    end
  )
end, { remap = true, buffer = true })

vim.keymap.set('n', 'gcd', function()
  vim.ui.input({ prompt = 'Path: ', completion = 'dir' }, function(input)
    if input and input ~= '' then vim.cmd('Ex ' .. input) end
  end)
end, { buffer = true, silent = true })
