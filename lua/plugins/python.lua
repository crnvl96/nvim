return {
    { 'nvim-lua/plenary.nvim' },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
    },
    {
        'linux-cultist/venv-selector.nvim',
        ft = 'python',
        branch = 'regexp',
        cmd = 'VenvSelect',
        opts = {
            settings = {
                options = {
                    notify_user_on_venv_activation = true,
                },
            },
        },
        keys = {
            { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv', ft = 'python' },
        },
    },
}
