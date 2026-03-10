Config.now_if_args(function() require('crnvl.plug._schemastore') end)
Config.now_if_args(function() require('crnvl.plug._sleuth') end)
Config.now_if_args(function() require('crnvl.plug._ts-autotag') end)
Config.now_if_args(function() require('crnvl.plug._ts-comments') end)

Config.now_if_args(function() require('crnvl.plug._image') end)
Config.now_if_args(function() require('crnvl.plug._img-clip') end)
Config.now_if_args(function() require('crnvl.plug._markdown-preview') end)
Config.now_if_args(function() require('crnvl.plug._typst-preview') end)

Config.now_if_args(function() require('crnvl.plug._conform') end)
Config.now_if_args(function() require('crnvl.plug._lspconfig') end)
Config.now_if_args(function() require('crnvl.plug._treesitter') end)

Config.now_if_args(function() require('crnvl.plug._mini-ai') end)
Config.now_if_args(function() require('crnvl.plug._mini-align') end)
Config.now_if_args(function() require('crnvl.plug._mini-bufremove') end)
Config.now_if_args(function() require('crnvl.plug._mini-clue') end)
Config.now_if_args(function() require('crnvl.plug._mini-cmdline') end)
Config.now_if_args(function() require('crnvl.plug._mini-completion') end)
Config.now_if_args(function() require('crnvl.plug._mini-files') end)
Config.now_if_args(function() require('crnvl.plug._mini-hipatterns') end)
Config.now_if_args(function() require('crnvl.plug._mini-indentscope') end)
Config.now_if_args(function() require('crnvl.plug._mini-jump2d') end)
Config.now_if_args(function() require('crnvl.plug._mini-keymap') end)
Config.now_if_args(function() require('crnvl.plug._mini-move') end)
Config.now_if_args(function() require('crnvl.plug._mini-operators') end)
Config.now_if_args(function() require('crnvl.plug._mini-pairs') end)
Config.now_if_args(function() require('crnvl.plug._mini-pick') end)
Config.now_if_args(function() require('crnvl.plug._mini-snippets') end)
Config.now_if_args(function() require('crnvl.plug._mini-splitjoin') end)
Config.now_if_args(function() require('crnvl.plug._mini-surround') end)

Config.now_if_args(
  function() vim.pack.add({ 'https://github.com/tpope/vim-fugitive' }) end
)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })

  require('gitsigns').setup({
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
    attach_to_untracked = true,
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, desc)
        vim.keymap.set(
          mode,
          l,
          r,
          { buffer = buffer, desc = desc, silent = true }
        )
      end
      map('n', ']h', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, 'Next Hunk')
      map('n', '[h', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, 'Prev Hunk')
      map('n', ']H', function() gs.nav_hunk('last') end, 'Last Hunk')
      map('n', '[H', function() gs.nav_hunk('first') end, 'First Hunk')
      map({ 'n', 'x' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
      map({ 'n', 'x' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
      map('n', '<leader>hS', gs.stage_buffer, 'Stage Buffer')
      map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo Stage Hunk')
      map('n', '<leader>hx', gs.setqflist, 'Set qflist')
      map('n', '<leader>hR', gs.reset_buffer, 'Reset Buffer')
      map('n', '<leader>hp', gs.preview_hunk_inline, 'Preview Hunk Inline')
      map(
        'n',
        '<leader>hb',
        function() gs.blame_line({ full = true }) end,
        'Blame Line'
      )
      map('n', '<leader>hB', function() gs.blame() end, 'Blame Buffer')
      map('n', '<leader>hd', gs.diffthis, 'Diff This')
      map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff This ~')
      map(
        { 'o', 'x' },
        'ih',
        ':<C-U>Gitsigns select_hunk<CR>',
        'GitSigns Select Hunk'
      )
    end,
  })
end)
