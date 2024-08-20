local project = require('project_nvim')
project.setup()

local telescope = require('telescope')
telescope.load_extension('projects')

vim.keymap.set('n', '<leader>pp', telescope.extensions.projects.projects)
